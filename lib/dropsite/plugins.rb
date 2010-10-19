PLUGINS_DIR = File.join(File.dirname(__FILE__), 'plugins')

Dir.entries(PLUGINS_DIR).reject {|e| e =~ /^\./}.each do |e|
  require File.join(PLUGINS_DIR, e, e)
end
