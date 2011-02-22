require File.join(File.dirname(__FILE__), 'helper')

class TestSiteFile < Test::Unit::TestCase
  def test_name
    assert_equal 'pic1.jpg', SiteFile.new('pic1.jpg').name
    assert_equal 'pic1.jpg', SiteFile.new('/pics/pic1.jpg').name
  end

  def test_type
    assert_equal :image, SiteFile.new('/pics/pic1.jpg').file_type
    assert_equal :image, SiteFile.new('/pics/pic1.gif').file_type
    assert_equal :text, SiteFile.new('/pics/pic1.txt').file_type
    assert_equal :unknown, SiteFile.new('/pics/plainoldfile').file_type
    assert_equal :unknown, SiteFile.new('/pics/file.asdf').file_type
  end

  def test_top_level
    assert SiteFile.new('/pic1.jpg').top_level?
    assert !SiteFile.new('/pics/pic1.jpg').top_level?
  end

  def test_size
    sf = SiteFile.new('/pic1.jpg')
    sf.size_in_bytes = 100
    assert_equal '100 B', sf.size
    sf.size_in_bytes = 1024
    assert_equal '1 KB', sf.size
    sf.size_in_bytes = 1536
    assert_equal '1.5 KB', sf.size
    sf.size_in_bytes = 1792
    assert_equal '1.8 KB', sf.size # rounded
    sf.size_in_bytes = 1048576
    assert_equal '1 MB', sf.size
    sf.size_in_bytes = 3879731
    assert_equal '3.7 MB', sf.size
    sf.size_in_bytes = 1073741824
    assert_equal '1 GB', sf.size
    sf.size_in_bytes = 1099511627776
    assert_equal '1 TB', sf.size
  end
end