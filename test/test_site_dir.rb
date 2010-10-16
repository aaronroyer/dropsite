require File.join(File.dirname(__FILE__), 'helper')

class TestSiteDir < Test::Unit::TestCase
  def test_name
    assert_equal 'pic1.jpg', SiteDir.new('pic1.jpg', [], '/tmp').name
    assert_equal 'pic1.jpg', SiteDir.new('/pics/pic1.jpg', [], '/tmp').name
  end
  
  def test_root_name
    assert_equal '/', SiteDir.new('/', [], '/tmp').name
    assert_equal '/', SiteDir.new('', [], '/tmp').name
  end
  
  def test_is_root
    assert SiteDir.new('/', [], '/tmp').root?
    assert SiteDir.new('', [], '/tmp').root?
    assert !SiteDir.new('/file.txt', [], '/tmp').root?
    assert !SiteDir.new('/dir', [], '/tmp').root?
    assert !SiteDir.new('/dir/file.txt', [], '/tmp').root?
  end
end