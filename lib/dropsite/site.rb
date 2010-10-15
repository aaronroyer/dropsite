module DropSite
  class Site
    attr_reader :site_root
    
    def initialize(config)
      if config.is_a? String
        @source = config
        @excludes = []
      else
        @config = config.clone
        @source = config['source']
        @excludes = config['excludes'] || []
      end
      
      @tree = nil
    end
    
    def process
      read
    end
    
    def read
      @site_root = read_directory
    end
    
    def read_directory(dir='')
      base = File.join(@source, dir)
      entries = filter_entries(Dir.entries(base))
      
      dirs = []
      files = []
      
      entries.each do |f|
        f_abs = File.join(base, f)
        f_rel = File.join(dir, f)
        if File.directory?(f_abs)
          dirs << read_directory(f_rel)
        elsif !File.symlink?(f_abs)
          files << SiteFile.new(f_rel)
        end
      end
      SiteDir.new(dir, dirs, files)
    end
    
    def filter_entries(entries)
      entries.reject do |e|
        ['.', '_', '#'].include?(e[0..0]) || e[-1..-1] == '~' || @excludes.include?(e)
      end
    end
  end
end
