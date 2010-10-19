module Dropsite
  class SiteDir < SiteItem
    attr_accessor :entries
    
    def initialize(path, entries, site_dir)
      @path = path == '/' ? '' : path
      @entries = entries
      @site_dir = site_dir
      @content = nil
    end
    
    def render
      @content = Dropsite::DirRenderer.find_renderer_and_render(self)
      dirs.each {|dir| dir.render}
    end
    
    def write
      if root?
        # The root site directory was created in Site
        index_file = File.join(@site_dir, 'index.html')
        puts "Writing top level index file at #{index_file}"
        File.open(index_file, 'w') {|f| f.puts @content}
      else
        # Sub-directories all need to be created here
        pieces = @path.sub(/^\//, '').split('/')
        dir_name = File.join(@site_dir, 'dropsite', *pieces)
        index_file = dir_name + '.html'
        puts "Writing index file at #{index_file}"
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
  end
end
