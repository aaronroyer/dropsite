module Dropsite
  class SiteFile < SiteItem
    EXTENSIONS = {
      'image' => %w[jpg jpeg gif png],
      'text' => %w[txt],
      'pdf' => %w[pdf]
    }
    
    attr_accessor :size_in_bytes
    
    def initialize(rel_path, abs_path=nil)
      @path = rel_path
      @size_in_bytes = File.size(abs_path) if abs_path
    end
    
    def file_type
      if File.extname(name).empty?
        'unknown'
      else
        ext = File.extname(name).sub(/^\./, '')
        EXTENSIONS.each {|k, v| return k if v.include? ext}
        return 'unknown'
      end
    end
    
    # Human readable file size
    def size
      return '' if !@size_in_bytes
      units = %w{B KB MB GB TB}
      e = (Math.log(@size_in_bytes)/Math.log(1024)).floor
      s = "%.1f" % (@size_in_bytes.to_f / 1024 ** e)
      s.sub(/\.?0*$/, " #{units[e]}")
    end
    
    def to_s
      "SiteFile(#{@path})"
    end
  end
end
