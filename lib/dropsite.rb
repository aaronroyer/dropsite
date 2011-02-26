module Dropsite
  VERSION = '0.3.1'
end

include Dropsite

%w[globals dir_renderer render_helper plugins site site_item site_dir site_file application].each do |lib|
  require File.join('dropsite', lib)
end
