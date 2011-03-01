require File.join(File.dirname(__FILE__), '..', 'helper')
require 'nokogiri'

class TestImageThumbnails < Test::Unit::TestCase

  def test_thumbnail_link
    sd = SiteDir.new('', [SiteFile.new('pic.jpg')], Site.new('/tmp'))
    sd.render

    doc = Nokogiri::HTML(sd.content)
    thumb_links = doc.css('.thumb-link')

    assert_equal 1, thumb_links.size
    assert_equal 'pic-thumb.jpg', File.basename(thumb_links.first.css('img').first.attribute('src').value)
  end

  # Test that a default thumbnail is linked for an image type for which a thumbnail
  # cannot be created
  def test_non_generateable_thumbnail_link
    sd = SiteDir.new('', [SiteFile.new('pic.art')], Site.new('/tmp'))
    sd.render

    doc = Nokogiri::HTML(sd.content)
    thumb_links = doc.css('.thumb-link')

    assert_equal 1, thumb_links.size
    assert_equal 'dropsite/dropsite-assets/image_thumbnails/images/icons/image-large.png',
      thumb_links.first.css('img').first.attribute('src').value
  end
end
