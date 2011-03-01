require 'fileutils'

class ImageThumbnails < Dropsite::DirRenderer
  VALID_THUMBNAIL_EXTENSIONS = %w[bmp gif jpeg jpg png tif tiff]

  def can_render?(site_dir)
    return false if not thumbnail_generator
    !site_dir.files.empty? && site_dir.files.all? {|e| e.file_type == :image}
  end

  def write_page_assets(site_dir)
    raise 'No thumbnail generator' if not thumbnail_generator

    assets_dir = site_dir.page_assets_dir
    site_dir.entries.find_all {|e| e.is_a? SiteFile}.each do |e|
      src_image = e.abs_path
      case thumbnail_generator
      when :image_science
        begin
          write_thumb_with_image_science(src_image, assets_dir)
        rescue RuntimeError => e # I believe this is as specific as it gets
          site_dir.warning "Could not create thumbnail for #{src_image} with ImageScience, " +
            "a possible reason is that ImageScience cannot create thumbs for animated gifs" +
            "\nError message: #{e.message}"
          write_default_thumbnail(src_image, site_dir)
        end
      when :rmagick
         begin
           write_thumb_with_rmagick(src_image, assets_dir)
          rescue ImageMagickError => e
            site_dir.warning "Could not create thumbnail for #{src_image} with RMagick\n#{e.message}"
            write_default_thumbnail(src_image, assets_dir)
          end
      else
        site_dir.error "Unrecognized thumbnail generator: #{thumbnail_generator}"
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

  def write_default_thumbnail(src_image, site_dir)
    # If not a valid extension then no thumbnail needs to be copied in, since at
    # render time it should not expect it to be there
    if VALID_THUMBNAIL_EXTENSIONS.include? File.extname(src_image).sub(/^\./, '')
      default_thumb = File.join(plugin_assets_dir, 'images', 'icons', "image-large#{File.extname(src_image)}")
      FileUtils.cp(default_thumb, File.join(site_dir.page_assets_dir, thumb_file_name(src_image)))
    end
  end
end
