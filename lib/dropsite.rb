
module Dropsite
  
  # Attempts to find the Dropbox directory (not the Public directory, the Dropbox base
  # directory) on this box. Returns nil if an existing directory could not be found.
  def find_dropbox_dir
    return ENV['DROPBOX_HOME'] if ENV['DROPBOX_HOME']
    
    path = case RUBY_PLATFORM
    when /darwin/, /linux/, /freebsd/
      File.join(ENV['HOME'], 'Dropbox')
    when /win32/, /mingw/
      File.join(ENV['USERPROFILE'], 'My Documents', 'My Dropbox')
    end
    
    File.exist?(path) ? path : nil
  end
  
  # Convert a camel-cased string into a lowercase, underscore separated string
  def underscorize(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").downcase
  end
end

%w[dir_renderer render_helper plugins site site_item site_dir site_file].each do |lib|
  require File.join('dropsite', lib)
end
