require 'test/unit'
require 'rubygems'

begin
  require 'redgreen' unless ENV['TM_MODE']
rescue LoadError
end

FILE_DIR = File.dirname(__FILE__)

require File.join(FILE_DIR, *%w[.. lib dropsite])
include DropSite

FIXTURES_DIR = File.join(FILE_DIR, 'fixtures')