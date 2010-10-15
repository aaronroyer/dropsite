module DropSite
  class SiteFile
    EXTENSIONS = {
      'image' => %w[jpg jpeg gif],
      'text' => %w[txt],
      'pdf' => %w[pdf]
    }
    
    attr_accessor :path
    
    def initialize(path)
      @path = path
    end
    
    def name
      File.basename @path
    end
    
    def file_type
      if File.extname(name).empty?
        'unknown'
      else
        ext = File.extname(name).sub /^\./, ''
        EXTENSIONS.each {|k, v| return k if v.include? ext}
      end
    end
    
    def get_binding
      binding
    end
    
    def to_s
      "SiteFile(#{@path})"
    end
  end
end