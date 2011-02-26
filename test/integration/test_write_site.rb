require File.join(File.dirname(__FILE__), '..', 'helper')
require 'fileutils'
require 'nokogiri'

# Integration tests, testing the complete site generation process
class TestWriteSite < Test::Unit::TestCase
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

  def test_write_only_simple_index_pages
    test_public_dir = File.join(TMP_DIR, 'simple_public')
    FileUtils.cp_r(File.join(FIXTURES_DIR, 'simple_public'), test_public_dir)
    site = Site.new(
      :public_dir => test_public_dir,
      :quiet => true,
      :disabled_plugins => ['image_thumbnails']
    )
    site.process

    # Check that all the index pages are there

    index_file = File.join(site.public_dir, 'index.html')
    assert File.exist?(index_file)
    index_doc = Nokogiri::HTML(IO.read(index_file))
    assert_equal 3, index_doc.css('.entry').size

    assert_equal 'dropsite/pics.html', index_doc.css('a').find {|a| a.content == 'pics'}.attribute('href').value

    site_dir = File.join(site.public_dir, 'dropsite')
    assert File.exist?(site_dir)
    assert File.directory?(site_dir)

    pics_file = File.join(site_dir, 'pics.html')
    assert File.exist?(pics_file)
    pics_doc = Nokogiri::HTML(IO.read(pics_file))
    assert_equal 3, pics_doc.css('.entry').size

    # Make sure the the links are correct

    ['leaves.jpg', 'sculpture.jpg'].each do |pic|
      assert_equal "../pics/#{pic}", pics_doc.css('a').find {|a| a.content == pic}.attribute('href').value
    end

    assert_equal 'pics/people.html', pics_doc.css('a').find {|a| a.content == 'people'}.attribute('href').value

    people_file = File.join(site_dir, 'pics', 'people.html')
    assert File.exist?(people_file)
    people_doc = Nokogiri::HTML(IO.read(people_file))
    assert_equal 2, people_doc.css('.entry').size

    ['beach.jpg', 'concert.jpg'].each do |pic|
      assert_equal "../../pics/people/#{pic}", people_doc.css('a').find {|a| a.content == pic}.attribute('href').value
    end

    # Check that the assets were copied in

    assets_dir = File.join(site.public_dir, 'dropsite', 'dropsite-assets')
    assert File.exist?(assets_dir)
    assert File.directory?(assets_dir)
    simple_index_assets_dir = File.join(assets_dir, 'simple_index')
    assert File.exist?(simple_index_assets_dir)
    assert File.directory?(simple_index_assets_dir)
    assert File.exist?(File.join(simple_index_assets_dir, 'css', 'simple_index.css'))

    # Check that the assets are included correctly

    assert_equal 1, index_doc.css('link').find_all {|l|
      l.attribute('href').value == 'dropsite/dropsite-assets/simple_index/css/simple_index.css'
    }.size
    assert_equal 1, index_doc.css('script').find_all {|l|
      l.attribute('src').value == 'dropsite/dropsite-assets/simple_index/js/simple_index.js'
    }.size

    assert_equal 1, pics_doc.css('link').find_all {|l|
      l.attribute('href').value == 'dropsite-assets/simple_index/css/simple_index.css'
    }.size
    assert_equal 1, pics_doc.css('script').find_all {|l|
      l.attribute('src').value == 'dropsite-assets/simple_index/js/simple_index.js'
    }.size

    assert_equal 1, people_doc.css('link').find_all {|l|
      l.attribute('href').value == '../dropsite-assets/simple_index/css/simple_index.css'
    }.size
    assert_equal 1, people_doc.css('script').find_all {|l|
      l.attribute('src').value == '../dropsite-assets/simple_index/js/simple_index.js'
    }.size
  end

  def test_write_with_image_thumbnails
    test_public_dir = File.join(TMP_DIR, 'simple_public')
    FileUtils.cp_r(File.join(FIXTURES_DIR, 'simple_public'), test_public_dir)
    site = Site.new(
      :public_dir => test_public_dir,
      :quiet => true
      # This time don't disable image_thumbnails
    )
    site.process

    # Just test the differences from test_write_only_simple_index_pages, trust
    # basic Dropsite setup is there

    # TODO: make sure code using both image libraries is tested

    people_thumbs_dir = File.join(test_public_dir, *%w[dropsite pics dropsite-people-assets])
    assert File.exist?(File.join(people_thumbs_dir, 'beach-thumb.jpg'))
    assert File.exist?(File.join(people_thumbs_dir, 'concert-thumb.jpg'))
  end
end
