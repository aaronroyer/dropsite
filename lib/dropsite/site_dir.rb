module Dropsite
  class SiteDir < SiteItem
    attr_accessor :path, :entries
    
    def initialize(path, entries)
      @path = path == '' ? '/' : path
      @entries = entries
    end
    
    def files
      @entries.find_all {|e| e.is_a? SiteFile}
    end
    
    def dirs
      @entries.find_all {|e| e.is_a? SiteDir}
    end
    
    def is_root?
      @path == '/'
    end
    
    def to_s
      "SiteDir(#{is_root? ? 'root' : @path})"
    end
  end
end