module DropSite
  class SiteDir
    attr_accessor :path, :dirs, :files
    
    def initialize(path, dirs, files)
      @path = path == '' ? '/' : path
      @dirs = dirs || []
      @files = files || []
    end
    
    def name
      File.basename @path
    end
    
    def is_root?
      @path == '/'
    end
    
    def get_binding
      binding
    end
    
    def to_s
      "SiteDir(#{is_root? ? 'root' : @path})"
    end
  end
end