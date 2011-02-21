module Dropsite
  class SiteDir < SiteItem
    attr_accessor :entries, :site

    def initialize(path, entries, site)
      @path = path == '/' ? '' : path
      @entries = entries
      @site = site
      @content = nil
    end

    def render
      @content = find_renderer.render(self)
      dirs.each {|dir| dir.render}
    end

    def write
      if root?
        # The root site directory was created in Site
        index_file = File.join(@site.public_dir, 'index.html')
        notice "Writing top level index file at #{index_file}"
        File.open(index_file, 'w') {|f| f.puts @content}
      else
        # Sub-directories all need to be created here
        pieces = @path.sub(/^\//, '').split('/')
        dir_name = File.join(@site.public_dir, 'dropsite', *pieces)
        index_file = dir_name + '.html'
        notice "Writing index file at #{index_file}"
        File.open(index_file, 'w') {|f| f.puts @content}
        Dir.mkdir(dir_name)
      end
      dirs.sort.each{|dir| dir.write}
    end

    def files
      @entries.find_all {|e| e.is_a? SiteFile}
    end

    def dirs
      @entries.find_all {|e| e.is_a? SiteDir}
    end

    def root?
      @path == ''
    end

    def file_type
      'directory'
    end

    def size
      ''
    end

    def to_s
      "SiteDir(#{is_root? ? 'root' : @path})"
    end

    protected

    # Find the first renderer that can render this SiteDir. Non-built-in (user) plugins
    # are searched first.
    def find_renderer
      DirRenderer.renderers.partition {|r| !r.built_in? }.flatten.find do |r|
        r.can_render?(self) && !plugin_disabled?(r)
      end
    end

    # Figures out whether the plugin with the given name is disabled. This matches against the
    # Site's disabled list, ignoring underscores and case.
    def plugin_disabled?(plugin)
      site.disabled_plugins.find {|p| p.gsub(/_/, '').downcase == plugin.gsub(/_/, '').downcase}
    end
  end
end
