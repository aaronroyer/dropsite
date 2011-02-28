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

    # Overridden in subclass to indicate, usually based on the SiteDir contents, whether
    # this renderer can render the SiteDir. This is false by default, unless the renderer
    # is a built_in (included with Dropsite).
    def can_render?(site_dir)
      built_in?
    end

    # Optionally overridden in subclass to do the work of rendering. By default this will
    # find plugin_name.erb in the plugin directory and use it to render.
    def render(site_dir)
      site_dir.rendered_by = self.class

      if File.extname(template_path) == '.erb'
        @template = @template || ERB.new(IO.read(template_path))
        @template.result(site_dir.get_binding)
      else
        raise "Don't know how to render: #{template_path}"
      end
    end

    # Optionally overridden in subclass to write any files that will be needed to display
    # the page (rendered by the render method) properly. This does nothing by default.
    def write_page_assets(site_dir)
    end

    def built_in?
      false
    end

    def plugin_assets_dir
      File.join(File.dirname(__FILE__), 'plugins', underscorize(self.class.name), 'assets')
    end
  end
end
