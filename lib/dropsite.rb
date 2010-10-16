THIS_DIR = File.dirname(__FILE__)
$:.unshift THIS_DIR

module Dropsite
  TEMPLATES_DIR = File.join(THIS_DIR, 'dropsite', 'templates')
  ASSETS_DIR = File.join(THIS_DIR, 'dropsite', 'assets')
end

%w[dir_renderer plugins site site_item site_dir site_file].each do |lib|
  require "dropsite/#{lib}"
end
