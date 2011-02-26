require File.join(File.dirname(__FILE__), '..', 'helper')

class TestSiteDir < Test::Unit::TestCase
  def test_name
    assert_equal 'pic1.jpg', SiteDir.new('pic1.jpg', [], Site.new('/tmp')).name
    assert_equal 'pic1.jpg', SiteDir.new('/pics/pic1.jpg', [], Site.new('/tmp')).name
  end

  def test_root_name
    assert_equal '', SiteDir.new('/', [], Site.new('/tmp')).name
    assert_equal '', SiteDir.new('', [], Site.new('/tmp')).name
  end

  def test_root
    assert SiteDir.new('', [], Site.new('/tmp')).root?
    assert !SiteDir.new('/file.txt', [], Site.new('/tmp')).root?
    assert !SiteDir.new('/dir', [], Site.new('/tmp')).root?
    assert !SiteDir.new('/dir/file.txt', [], Site.new('/tmp')).root?
  end

  def test_page_assets_dir
    sd = SiteDir.new('', [], Site.new('/tmp'))
    assert_equal '/tmp/dropsite/dropsite-root-index-directory-assets', sd.page_assets_dir

    sd = SiteDir.new('/thisisadir', [], Site.new('/tmp'))
    assert_equal '/tmp/dropsite/dropsite-thisisadir-assets', sd.page_assets_dir

    sd = SiteDir.new('/two/dirs-up', [], Site.new('/tmp'))
    assert_equal '/tmp/dropsite/two/dropsite-dirs-up-assets', sd.page_assets_dir
  end
end
