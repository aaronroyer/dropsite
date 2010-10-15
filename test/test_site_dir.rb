require File.join(File.dirname(__FILE__), 'helper')

class TestSiteDir < Test::Unit::TestCase
  def test_name
    assert_equal 'pic1.jpg', SiteDir.new('pic1.jpg', [], []).name
    assert_equal 'pic1.jpg', SiteDir.new('/pics/pic1.jpg', [], []).name
  end
  
  def test_root_name
    assert_equal '/', SiteDir.new('/', [], []).name
    assert_equal '/', SiteDir.new('', [], []).name
  end
  
  def test_is_root
    assert SiteDir.new('/', [], []).is_root?
    assert SiteDir.new('', [], []).is_root?
    assert !SiteDir.new('/file.txt', [], []).is_root?
    assert !SiteDir.new('/dir', [], []).is_root?
    assert !SiteDir.new('/dir/file.txt', [], []).is_root?
  end
end