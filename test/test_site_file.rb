require File.join(File.dirname(__FILE__), 'helper')

class TestSiteFile < Test::Unit::TestCase
  def test_name
    assert_equal 'pic1.jpg', SiteFile.new('pic1.jpg').name
    assert_equal 'pic1.jpg', SiteFile.new('/pics/pic1.jpg').name
  end
  
  def test_type
    assert_equal 'image', SiteFile.new('/pics/pic1.jpg').file_type
    assert_equal 'image', SiteFile.new('/pics/pic1.gif').file_type
    assert_equal 'text', SiteFile.new('/pics/pic1.txt').file_type
    assert_equal 'unknown', SiteFile.new('/pics/plainoldfile').file_type
  end
end