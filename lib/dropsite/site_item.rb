module Dropsite
  class SiteItem
    include Enumerable, RenderHelper
    
    attr_accessor :path
    
    def name
      File.basename @path
    end
    
    def top_level?
      @path.sub(/^\//, '') == name
    end
    
    def <=>(other)
      name <=> other.name
    end
  end
end
