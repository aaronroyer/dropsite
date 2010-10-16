module Dropsite
  class SiteItem
    include Enumerable
    
    def name
      File.basename @path
    end
    
    
    def link
      if top_level? && (!is_a? SiteDir)
        name
      else
        if is_a? SiteDir # TODO: do a dynamic renderable test?
          top_level? ? "site/#{@path}.html" : "#{@path}.html".sub(/^\//, '')
        else
          # Builds a link back up to the file in Public root since the pages
          # are built in a parallel directory structure
          dirs_up = @path.split('/').size - 1
          (['..'] * dirs_up).join('/') + "/#{@path}"
        end
      end
    end
    
    def top_level?
      @path.sub(/^\//, '') == name
    end
    
    def get_binding
      binding
    end
    
    def <=>(other)
      name <=> other.name
    end
  end
end
