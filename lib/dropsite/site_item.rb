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

    def notice(msg)
      @site.notice(msg) if @site
    end

    def warning(msg)
      @site.warning(msg) if @site
    end

    def error(msg)
      @site.error(msg) if @site
    end
  end
end
