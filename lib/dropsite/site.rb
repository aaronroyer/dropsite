require 'fileutils'

module Dropsite
  class Site
    attr_reader :site_tree, :public_dir
    
    def initialize(config)
      if config.is_a? String
        @public_dir = config
        @excludes = []
      else
        @config = config.clone
        @public_dir = config[:source]
        @excludes = config[:excludes] || []
      end
      
      @site_tree = nil
    end
    
    def process
      read
      render
      write
    end
    
    def read
      @site_tree = read_directory
    end
    
    def render
      @site_tree.render
    end
    
    def write
      site_dir = File.join(@public_dir, 'dropsite')
      puts "Creating root site dir at #{site_dir}"
      Dir.mkdir(site_dir)
      @site_tree.write
      
      site_assets_dir = File.join(site_dir, 'dropsite-assets')
      Dir.mkdir(site_assets_dir)
      DirRenderer.renderers.each do |r|
        if File.exist? r.assets_dir
          FileUtils.cp_r(r.assets_dir, File.join(site_assets_dir, Dropsite.underscore(r.class.to_s)))
        end
      end
    end
    
    protected
    
    def read_directory(dir='')
      base = File.join(@public_dir, dir)
      entries = filter_entries(Dir.entries(base))
      
      dir_entries = []
      
      entries.each do |f|
        f_abs = File.join(base, f)
        f_rel = File.join(dir, f).sub(/^\//, '')
        if File.directory?(f_abs)
          dir_entries << read_directory(f_rel)
        elsif !File.symlink?(f_abs)
          dir_entries << SiteFile.new(f_rel, f_abs)
        end
      end
      SiteDir.new(dir, dir_entries, @public_dir)
    end
    
    def filter_entries(entries)
      entries.reject do |e|
        ['.', '_', '#'].include?(e[0..0]) || e[-1..-1] == '~' || @excludes.include?(e)
      end
    end
  end
end
