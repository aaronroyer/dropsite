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
    
    def DirRenderer.renderers
      @@renderers
    end
    
    # Find the first renderer that can render the given SiteDir. Non-default (user) plugins
    # are searched first.
    def DirRenderer.find_renderer(site_dir)
      @@renderers.partition {|r| !r.is_default? }.flatten.find {|r| r.can_render?(site_dir)}
    end
    
    def DirRenderer.find_renderer_and_render(site_dir)
      DirRenderer.find_renderer(site_dir).render(site_dir)
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
      is_default?
    end
    
    def is_default?
      false
    end
  end
end
