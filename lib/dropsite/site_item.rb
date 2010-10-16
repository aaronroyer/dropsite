module Dropsite
  class SiteItem
    include Enumerable
    
    def name
      File.basename @path
    end
    
    def get_binding
      binding
    end
    
    def <=>(other)
      @name <=> other.name
    end
  end
end