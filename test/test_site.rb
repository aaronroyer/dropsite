require File.join(File.dirname(__FILE__), 'helper')

class TestSite < Test::Unit::TestCase
  def test_create_site_tree_from_simple_public_dir
    site = Site.new(File.join(FIXTURES_DIR, 'simple_public'))
    top_level = site.read
    
    assert top_level.is_a? SiteDir
    assert_equal '/', top_level.path
    assert_equal 2, top_level.files.size
    assert top_level.files.find {|f| f.name == 'file1.txt'}
    assert top_level.files.find {|f| f.name == 'file2.txt'}
    assert_equal 1, top_level.dirs.size
    
    pics_dir = top_level.dirs[0]
    assert_equal 'pics', pics_dir.path
    assert_equal 2, pics_dir.files.size
    
    assert pics_dir.files.find {|f| f.name == 'leaves.jpg'}
    assert pics_dir.files.find {|f| f.name == 'sculpture.jpg'}
    assert_equal 1, pics_dir.dirs.size
    
    people_dir = pics_dir.dirs[0]
    assert_equal 2, people_dir.files.size
    assert people_dir.files.find {|f| f.name == 'concert.jpg'}
    assert people_dir.files.find {|f| f.name == 'beach.jpg'}
    assert people_dir.dirs.empty?
  end
  
  def test_create_site_tree_from_simple_public_dir_with_exclusions
    site = Site.new(
      :source => File.join(FIXTURES_DIR, 'simple_public'),
      :excludes => ['pics', 'file1.txt']
    )
    top_level = site.read
    
    assert_equal 1, top_level.files.size
    assert top_level.files.find {|f| f.name == 'file2.txt'}
    assert top_level.dirs.empty?
  end
end