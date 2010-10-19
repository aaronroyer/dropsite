require File.join(File.dirname(__FILE__), 'helper')
require 'fileutils'
require 'nokogiri'

class TestWriteSite < Test::Unit::TestCase
  TMP_DIR = File.join(FIXTURES_DIR, 'tmp')
  
  def setup
    clean_tmp_dir
  end
  
  def teardown
    clean_tmp_dir
  end
  
  def test_simple_process
    FileUtils.cp_r(File.join(FIXTURES_DIR, 'simple_public'), File.join(TMP_DIR, 'simple_public'))
    site = Site.new(File.join(TMP_DIR, 'simple_public'))
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
  
  protected
  
  def clean_tmp_dir
     Dir.entries(TMP_DIR).reject {|e| e =~ /^\./}.each do |entry|
        file = File.join(TMP_DIR, entry)
        if File.directory?(file)
          FileUtils.rm_rf(file)
        else
          File.delete(file)
        end
      end
  end
end
