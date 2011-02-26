require File.join(File.dirname(__FILE__), '..', 'helper')
require 'fileutils'
require 'nokogiri'

class TestProcessSiteManyFolders < Test::Unit::TestCase
  include Fixtures

  def setup; clean_tmp_dir end

  def test_process_with_many_folders
    test_public_dir = File.join(TMP_DIR, 'many_folders_public')
    FileUtils.cp_r(File.join(FIXTURES_DIR, 'many_folders_public'), test_public_dir)
    site = Site.new(:public_dir => test_public_dir, :quiet => true)
    site.process

    # TODO: add some tests
  end
end
