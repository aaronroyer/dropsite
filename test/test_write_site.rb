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
    
    # Check that all the index pages are there with correct links
    
    index_file = File.join(site.public_dir, 'index.html')
    assert File.exist?(index_file)
    index_doc = Nokogiri::HTML(IO.read(index_file))
    assert_equal 3, index_doc.css('div.entry').size
    
    assert_equal 'site/pics.html', index_doc.css('a').find {|a| a.content == 'pics'}.attribute('href').value
    
    site_dir = File.join(site.public_dir, 'site')
    assert File.exist?(site_dir)
    assert File.directory?(site_dir)
    
    pics_file = File.join(site_dir, 'pics.html')
    assert File.exist?(pics_file)
    pics_doc = Nokogiri::HTML(IO.read(pics_file))
    assert_equal 3, pics_doc.css('div.entry').size
    
    ['leaves.jpg', 'sculpture.jpg'].each do |pic|
      assert_equal "../pics/#{pic}", pics_doc.css('a').find {|a| a.content == pic}.attribute('href').value
    end
    
    assert_equal 'pics/people.html', pics_doc.css('a').find {|a| a.content == 'people'}.attribute('href').value
    
    people_file = File.join(site_dir, 'pics', 'people.html')
    assert File.exist?(people_file)
    people_doc = Nokogiri::HTML(IO.read(people_file))
    assert_equal 2, people_doc.css('div.entry').size
    
    ['beach.jpg', 'concert.jpg'].each do |pic|
      assert_equal "../../pics/people/#{pic}", people_doc.css('a').find {|a| a.content == pic}.attribute('href').value
    end
    
    # Check that the assets were copied in
    
    assets_dir = File.join(site.public_dir, 'site', 'dropsite-assets')
    assert File.exist?(assets_dir)
    assert File.directory?(assets_dir)
    simple_index_assets_dir = File.join(assets_dir, 'simple_index')
    assert File.exist?(simple_index_assets_dir)
    assert File.directory?(simple_index_assets_dir)
    assert File.exist?(File.join(simple_index_assets_dir, 'simple_index.css'))
  end
  
  protected
  
  def clean_tmp_dir
     Dir.entries(TMP_DIR).reject {|e| e =~ /^\./}.each do |entry|
        file = File.join(TMP_DIR, entry)
        puts "deleting #{file}"
        if File.directory?(file)
          FileUtils.rm_rf(file)
        else
          File.delete(file)
        end
      end
  end
end
