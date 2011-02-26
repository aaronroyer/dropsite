require File.join(File.dirname(__FILE__), '..', 'helper')
require 'fileutils'
require 'nokogiri'

class TestProcessSiteWithThumbnails < Test::Unit::TestCase
  include Fixtures

  def setup
    clean_tmp_dir
    # Don't use the regular ~/.ruby_inline dir (ImageScience uses RubyInline) and leave
    # the cached compiled code there, it causes some problems when testing with different
    # Ruby versions. Delete it after every test.
    ENV['INLINEDIR'] = File.join(TMP_DIR, 'ruby_inline')
    Dir.mkdir(ENV['INLINEDIR'])
  end

  def teardown
    clean_tmp_dir
  end

  def test_process_with_image_thumbnails
    test_public_dir = File.join(TMP_DIR, 'simple_public')
    FileUtils.cp_r(File.join(FIXTURES_DIR, 'simple_public'), test_public_dir)
    site = Site.new(
      :public_dir => test_public_dir,
      :quiet => true
      # Don't disable image_thumbnails
    )
    site.process

    # Just test the differences from processing with simple index pages, trust
    # basic Dropsite setup is there

    # TODO: make sure code using both image libraries is tested

    people_thumbs_dir = File.join(test_public_dir, *%w[dropsite pics dropsite-people-assets])
    assert File.exist?(File.join(people_thumbs_dir, 'beach-thumb.jpg'))
    assert File.exist?(File.join(people_thumbs_dir, 'concert-thumb.jpg'))
  end
end
