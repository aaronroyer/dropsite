module Dropsite
  
  # Helper methods, accessible in templates, to be included in renderable items
  module RenderHelper
    attr_accessor :rendered_by
    
    def link
      if top_level? && (!is_a? SiteDir)
        name
      else
        if is_a? SiteDir # TODO: do a dynamic renderable test?
          top_level? ? "dropsite/#{@path}.html" : "#{@path}.html".sub(/^\//, '')
        else
          # Builds a link back up to the file in Public root since the pages
          # are built in a parallel directory structure
          dirs_up = @path.split(File::SEPARATOR).size - 1
          (['..'] * dirs_up).join('/') + "/#{@path}"
        end
      end
    end
    
    def stylesheet_link_tag(stylesheet_name)
      stylesheet_name = "#{stylesheet_name}.css" if not stylesheet_name =~ /\.css$/
      %{<link rel="stylesheet" href="#{assets_link_base}css/#{stylesheet_name}" type="text/css" media="screen">}
    end
    
    def javascript_include_tag(javascript_file_name)
      javascript_file_name = "#{javascript_file_name}.js" if not javascript_file_name =~ /\.js$/
      %{<script type="text/javascript" src="#{assets_link_base}js/#{javascript_file_name}"></script>}
    end
    
    def image_tag(image_file_name)
      %{<img src="#{assets_link_base}images/#{image_file_name}" />}
    end
    
    def parent_directory_link_tag(levels_up=1, options={})
      %{<a href="#{back_link(levels_up)}"#{tag_attributes(options)}>#{parent_dir_name(levels_up)}</a>}
    end
    
    def each_parent_directory_link_tag(*args)
      include_root = true
      include_root = args[0] if args.size > 0 && (!args[0].is_a? Hash)
      options = args.find {|arg| arg.is_a? Hash}
      options = {} if !options
      
      levels_up = path.split('/').size
      levels_up = levels_up - 1 if !include_root
      levels_up.downto(1).each do |level_up|
        yield parent_directory_link_tag(level_up, options)
      end
    end
    
    def assets_link_base
      if root?
        "dropsite/dropsite-assets/#{Dropsite.underscore(rendered_by)}/"
      else
        # Work our way BACK up the path - crazy, right? Gotta do it though.
        dirs_up = path.split(File::SEPARATOR).size - 1
        (['..'] * dirs_up).join('/') + "#{'/' if dirs_up > 0}dropsite-assets/#{Dropsite.underscore(rendered_by)}/"
      end
    end
    
    # Get a link to a parent page
    def back_link(levels_up=1)
      # TODO: factor this out a bit between parent_dir_name
      if levels_up.is_a?(Integer) && levels_up > 0 && levels_up < path.split('/').size
        dir_name = path.split('/')[(levels_up + 1) * -1]
        dir_name = 'index' if dir_name.empty?
        (['..'] * (levels_up)).join('/') + "/#{dir_name}.html"
      else
        # Give the root index if we're confused
        root? ? '' : (['..'] * (path.split('/').size)).join('/') + '/index.html'
      end
    end
    
    def parent_dir_name(levels_up=1)
      if levels_up.is_a?(Integer) && levels_up > 0 && levels_up < path.split('/').size
        dir_name = path.split('/')[(levels_up + 1) * -1]
        dir_name.empty? ? 'index' : dir_name
      else
        # TODO: make this configurable
        'my files'
      end
    end
    
    def get_binding
      binding
    end
    
    protected
    
    def tag_attributes(options)
      options.empty? ? '' : ' ' + options.keys.map {|k| %{#{k.to_s}="#{options[k].to_s}"} }.join
    end
  end
end