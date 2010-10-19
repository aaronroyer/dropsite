
module Dropsite
  @@dropbox_dir = nil
  
  def dropbox_dir
    return @@dropbox_dir if @@dropbox_dir
    
    if ENV['DROPBOX_HOME']
      return @@dropbox_dir = ENV['DROPBOX_HOME']
    end
    
    @@dropbox = if RUBY_PLATFORM.downcase.include?("darwin")
      File.join(ENV['HOME'], 'Dropbox')
    end
  end
  
  def dropbox_dir=(dir)
    @@dropbox_dir = dir
  end
  
  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").downcase
  end
end

%w[dir_renderer render_helper plugins site site_item site_dir site_file].each do |lib|
  require "dropsite/#{lib}"
end
