require 'optparse'
require 'ostruct'
require 'yaml'

module Dropsite
  class Application
    def run
      handle_options

      options.dropbox_home = Dropsite.dropbox_dir if not options.dropbox_home

      if !options.dropbox_home || !File.exist?(options.dropbox_home)
        $stderr.puts 'Dropbox home directory cannot be found or does not exist'
        $stderr.puts 'Set valid directory with --dropbox-home DIRECTORY'
        exit 1
      end

      if options.create_config_dir
        create_config_dir
      else
        options.public_dir = File.join(options.dropbox_home, 'Public')
        cf = ConfigFile.new
        if cf.exist?
          options.exclude = cf.exclude
        end
        site = Dropsite::Site.new(options)
        site.process
      end
    end

    def options
      @options ||= OpenStruct.new
    end

    def create_config_dir
      if Dropsite.dropsite_config_dir
        puts "Config directory already exists at: #{Dropsite.dropsite_config_dir}"
        exit
      end

      config_dir = File.join(Dropsite.dropbox_dir, '.dropsite')
      Dir.mkdir(config_dir)
      File.open(File.join(config_dir, 'config.yml'), 'w') do |f|
        # TODO: put the contents in there
        f.puts ''
      end
      Dir.mkdir(File.join(config_dir, 'plugins'))
    end

    private

    def handle_options
      OptionParser.new do |opts|
        opts.on('-d', '--dropbox-home [PATH]', 'Specify Dropbox directory') do |path|
          options.dropbox_home = path
        end
        opts.on('-q', '--quiet', 'Suppress site processing output') do
          options.quiet = true
        end
        opts.on('-c', '--create-config-files', 'Create a dropsite config dir in the Dropbox home') do
          options.create_config_dir = true
        end
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
        opts.on_tail('--version', 'Show version') do
          puts "Dropsite version: #{Dropsite::VERSION}"
          exit
        end
      end.parse!
    end
  end

  # Wraps the main configuration file. Exists mostly in case of future
  # expansion of configuration options.
  class ConfigFile
    attr_reader :path, :exclude

    def initialize(path=nil)
      @path = path || Dropsite.dropsite_config_dir ?
        File.join(Dropsite.dropsite_config_dir, 'config.yml') : ''
    end

    def read
      return if not exist?
      config = YAML::load(IO.read(path))
      @exclude = config['exclude']
      self
    end

    def exist?
      File.exist? path
    end
  end
end
