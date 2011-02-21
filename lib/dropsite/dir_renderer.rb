require 'erb'

module Dropsite
  class DirRenderer
    TEMPLATE_EXTENSIONS = ['.erb']

    @@renderers = []

    def self.inherited(subclass)
      renderer = subclass.new

      plugin_dir = File.dirname(caller[0].split(':')[0])
      template_file = Dir.entries(plugin_dir).find {|e| TEMPLATE_EXTENSIONS.include? File.extname(e)}
      renderer.template_path = template_file ? File.join(plugin_dir, template_file) : nil
      renderer.assets_dir = File.join(plugin_dir, 'assets')
      @@renderers << renderer
    end

    def self.renderers
      @@renderers
    end

    attr_accessor :template_path, :assets_dir

    # Overridden in subclass if you don't want to just find and use a template
    def render(site_dir)
      site_dir.rendered_by = self.class

      if File.extname(template_path) == '.erb'
        @template = @template || ERB.new(IO.read(template_path))
        @template.result(site_dir.get_binding)
      else
        raise "Don't know how to render: #{template_path}"
      end
    end

    # Overriden in subclass or this won't do jack
    def can_render?(site_dir)
      built_in?
    end

    def built_in?
      false
    end
  end
end
