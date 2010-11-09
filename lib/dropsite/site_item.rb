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
    
    protected
    
    def notice(message)
      @site.notice(message) if @site
    end
  end
end
