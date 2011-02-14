require 'test/unit'
require 'rubygems'

begin
  require 'redgreen' unless ENV['TM_MODE']
rescue LoadError
end

require File.join(File.dirname(__FILE__), *%w[.. lib dropsite])
include Dropsite

# Fixtures and tmp dir helpers
module Fixtures
  FIXTURES_DIR = File.join(File.dirname(__FILE__), 'fixtures')
  TMP_DIR = File.join(FIXTURES_DIR, 'tmp')

  def clean_tmp_dir
    Dir.entries(TMP_DIR).reject {|e| %w[. .. .gitignore].include? e}.each do |entry|
    file = File.join(TMP_DIR, entry)
    if File.directory?(file)
      FileUtils.rm_rf(file)
    else
      File.delete(file)
    end
end
  end
end
