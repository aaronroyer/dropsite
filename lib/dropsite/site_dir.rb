module Dropsite
  class SiteDir < SiteItem
    attr_accessor :entries
    attr_reader :site, :path, :content

    def initialize(path, entries, site)
      @path = path == '/' ? '' : path
      @entries = entries
      @site = site
      @content = nil
    end

    def render
      @content = renderer.render(self)
      dirs.each {|dir| dir.render}
    end

    # Writes the page for this directory, plus any additional files needed by the page.
    def write
      if root?
        index_file = File.join(page_dir, 'index.html')
        notice "Writing top level index file at #{index_file}"
        File.open(index_file, 'w') {|f| f.puts content}
      else
        # First create the index page
        index_file = File.join(page_dir, name + '.html')
        notice "Writing index file for directory #{path} at #{index_file}"
        File.open(index_file, 'w') {|f| f.puts content}

        # Create a directory to contain index pages for any child directories
        Dir.mkdir(File.join(page_dir, name))
      end
      dirs.sort.each{|dir| dir.write}

      # Determine if the page assets directory is necessary, to avoid clutter
      writing_page_assets = true
      begin
        # Detect whether the write_page_assets method is overridden
        # In case this explodes in 1.8.6 we'll always create the directory
        writing_page_assets = renderer.class.instance_method(:write_page_assets).owner != DirRenderer
      rescue
      end

      # The renderer knows what assets are linked to and what needs to be available
      # to display the page properly
      if writing_page_assets
        Dir.mkdir(page_assets_dir)
        renderer.write_page_assets(self)
      end
    end

    # All regular files in this directory
    def files; entries.find_all {|e| e.is_a? SiteFile} end

    # All directories in this directory
    def dirs; entries.find_all {|e| e.is_a? SiteDir} end

    # Is this the site root directory?
    def root?; path == '' end

    # The file type is always 'directory'
    def file_type; 'directory' end

    # The human readable size is blank
    def size; '' end

    # Directory where the page will be written
    def page_dir
      if root?
        site.public_dir
      else
        pieces = path.sub(/^\//, '').split('/')
        File.join(site.site_files_dir, *pieces[0..-2])
      end
    end

    # Directory to store extra files needed by the page rendered to represent this directory.
    # This will almost always be the directory the page is in, except for the case of the
    # root index page. Since the root index page is in Dropbox/Public and we don't want to
    # pollute that directory we put the assets in the root of the dropsite directory.
    def page_assets_dir
      File.join(root? ? site.site_files_dir : page_dir, page_assets_dir_name)
    end

    def to_s
      "SiteDir(#{is_root? ? 'root' : path})"
    end

    protected

    def page_assets_dir_name
      "dropsite-#{root? ? 'root-index-directory' : name}-assets"
    end

    # Find the first renderer that can render this SiteDir. Non-built-in (user) plugins
    # are searched first.
    def renderer
      DirRenderer.renderers.partition {|r| !r.built_in?}.flatten.find do |r|
        r.can_render?(self) && !plugin_disabled?(r)
      end
    end

    # Figures out whether the plugin with the given name is disabled. This matches against the
    # Site's disabled list, ignoring underscores and case.
    def plugin_disabled?(plugin)
      site.disabled_plugins.find do |p|
        p.gsub(/_/, '').downcase == plugin.class.name.gsub(/_/, '').downcase
      end
    end
  end
end
