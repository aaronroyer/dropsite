module Dropsite
  # Attempts to find the Dropbox directory (not the Public directory, the Dropbox base
  # directory) on this box. Returns nil if an existing directory could not be found.
  def dropbox_dir
    return ENV['DROPBOX_HOME'] if ENV['DROPBOX_HOME']

    path = case RUBY_PLATFORM
    when /darwin/, /linux/, /freebsd/
      File.join(home_dir, 'Dropbox')
    when /win32/, /mingw/
      File.join(home_dir, 'My Documents', 'My Dropbox')
    end

    File.exist?(path) ? path : nil
  end

  # Find the configuration directory for Dropsite. The folder .dropsite is
  # looked for from most "local" to the Public folder outward. First in the
  # Public folder, then the Dropsite directory itself (recommended place) and
  # then the user's home directory.
  def dropsite_config_dir
    config_dir_name = '.dropsite'
    [
      File.join(dropbox_dir, 'Public', config_dir_name),
      File.join(dropbox_dir, config_dir_name),
      File.join(home_dir, config_dir_name)
    ].find {|dir| File.exist? dir}
  end

  # Platform-specific home directory
  def home_dir
    home = ENV['HOME']
    home = ENV['USERPROFILE'] if not home
    if !home && (ENV['HOMEDRIVE'] && ENV['HOMEPATH'])
      home = File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'])
    end
    home = File.expand_path('~') if not home
    home = 'C:/' if !home && RUBY_PLATFORM =~ /mswin|mingw/
    home
  end

  # Convert a camel-cased string into a lowercase, underscore separated string
  def underscorize(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").downcase
  end
end

%w[dir_renderer render_helper plugins site site_item site_dir site_file application].each do |lib|
  require File.join('dropsite', lib)
end
