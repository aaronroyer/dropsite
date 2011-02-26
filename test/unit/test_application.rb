require File.join(File.dirname(__FILE__), '..', 'helper')

class TestApplication < Test::Unit::TestCase
  include Fixtures

  def setup; clean_tmp_dir end
  def teardown; clean_tmp_dir end

  def test_create_config_files
    ENV['DROPBOX_HOME'] = TMP_DIR
    ARGV << '-c'
    Application.new.run

    config_dir = File.join(TMP_DIR, '.dropsite')
    assert File.directory?(config_dir), 'Config dir created'
    assert File.file?(File.join(config_dir, 'config.yml')), 'Main config file created'
    assert File.directory?(File.join(config_dir, 'plugins')), 'plugins dir created'
  end
end
