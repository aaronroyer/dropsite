require File.join(File.dirname(__FILE__), '..', 'helper')

class TestConfigFile < Test::Unit::TestCase
  include Fixtures

  def setup
    clean_tmp_dir
    ENV['DROPBOX_HOME'] = TMP_DIR
    config_dir = File.join(TMP_DIR, '.dropsite')
    Dir.mkdir(config_dir) if !File.exist?(config_dir)
  end

  def teardown; clean_tmp_dir end

  def test_read_exclude
    write_config_file <<-YAML
exclude: [ignore_this, and_also_this]
YAML

    cf = ConfigFile.new
    cf.read

    es = cf.exclude
    assert_equal 2, es.size
    assert es.include?('ignore_this')
    assert es.include?('and_also_this')
  end

  private

  def write_config_file(content)
    File.open(File.join(TMP_DIR, '.dropsite', 'config.yml'), 'w') {|f| f.puts content}
  end
end