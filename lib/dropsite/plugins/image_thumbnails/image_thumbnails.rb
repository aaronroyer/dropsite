class ImageThumbnails < Dropsite::DirRenderer
  def can_render?(site_dir)
    return false if not thumbnail_generator
    site_dir.files.all? {|e| e.file_type == :image}
  end

  def write_page_assets(site_dir)
    raise 'No thumbnail generator' if not thumbnail_generator

    assets_dir = site_dir.page_assets_dir
    site_dir.entries.find_all {|e| e.is_a? SiteFile}.each do |e|
      src_image = e.abs_path
      case thumbnail_generator
      when :image_science
        write_thumb_with_image_science(src_image, assets_dir)
      when :rmagick
        write_thumb_with_rmagick(src_image, assets_dir)
      else
        raise "Unrecognized thumbnail generator: #{thumbnail_generator}"
      end
    end
  end

  def built_in?
    true
  end

  def thumbnail_generator
    return @thumbnail_generator_cache if instance_variables.include?('@thumbnail_generator_cache')

    begin
      require 'image_science'
      return @thumbnail_generator_cache = :image_science
    rescue LoadError
    end

    begin
      require 'rmagick'
      return @thumbnail_generator_cache = :rmagick
    rescue LoadError
    end

    return @thumbnail_generator_cache = nil
  end

  protected

  def write_thumb_with_image_science(src_image, assets_dir)
    ImageScience.with_image(src_image) do |img|
      img.cropped_thumbnail(100) do |thumb|
        thumb.save(File.join(assets_dir, thumb_file_name(src_image)))
      end
    end
  end

  def write_thumb_with_rmagick(src_image, assets_dir)
    img = Magick::Image::read(src_image).first
    thumb = img.resize_to_fill(100, 100)
    thumb.write File.join(assets_dir, thumb_file_name(src_image))
  end

  def thumb_file_name(image_file_name)
    File.basename(image_file_name).sub(/\.\w+$/, '') + '-thumb' + File.extname(image_file_name)
  end
end
