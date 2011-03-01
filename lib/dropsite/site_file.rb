module Dropsite
  class SiteFile < SiteItem
    EXTENSIONS = {
      :audio => %w[abs aif aifc aiff au kar m3u mid midi mp1 mp2 mp3 mpa mpega pls smf snd ulw wav],
      :excel => %w[xls xlsx],
      :image => %w[art bmp dib gif ief jpe jpeg jpg mac pbm pct pgm pic pict png pnm pnt ppm psd qti qtif ras rgb svg svgz tif tiff wbmp xbm xpm xwd],
      :pdf => %w[pdf],
      :ruby => %w[rb rhtml erb],
      :text => %w[body css etx htc htm html jad java js rtf rtx tsv txt wml wmls],
      :video => %w[asf asx avi avx dv flv mov movie mp4 mpe mpeg mpg mpv2 qt wmv],
      :word => %w[doc docx]
    }

    attr_accessor :size_in_bytes, :abs_path

    def initialize(rel_path, abs_path=nil, site=nil)
      @path = rel_path
      @abs_path = abs_path
      @size_in_bytes = File.size(abs_path) if abs_path
      @site = site
    end

    def file_type
      if File.extname(name).empty?
        :unknown
      else
        ext = File.extname(name).sub(/^\./, '')
        EXTENSIONS.each {|k, v| return k if v.include? ext}
        return :unknown
      end
    end

    # Human readable file size
    def size
      return '' if !@size_in_bytes
      return '0 B' if @size_in_bytes == 0
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
