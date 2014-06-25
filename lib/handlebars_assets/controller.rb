require 'handlebars_assets/responder'

module HandlebarsAssets
  # Prepare a controller to use <code>respond_with</code>
  # to render a Handlebars template (for GET requests, currently)
  #
  # You must require 'handlebar_assets/controller' in your
  # controller, as it is not loaded by default.
  #
  #   require 'handlebars_assets/controller'
  #
  #   class MyApp < ActionController::Base
  #     include HandlebarsAssets::Controller
  #
  #     respond_to :hbs # or :handlebars
  #
  #     def show
  #       @bike = Bike.find(params[:id])
  #       render_with(@bike) # Look ma, no 'to_hbs'!
  #     end
  #   end
  #
  # Your class must define #to_hbs (or #to_handlebars)
  # that returns a Hash of JSON-compatible objects.
  #
  # You can specify the location of your templates:
  #
  #   handlebars_templates path: 'app/assets/...'
  #
  # -or-
  #
  #   handlebars_templates paths: ['array', 'of', 'paths']
  #
  # 'app/assets/javascripts/templates' is prepended on
  # include, so you do not need to add this line
  # if you keep your templates in that directory
  #
  # If you support other mime types (like JSON), in the same
  # controller, you'll need to give your template a 'js' or
  # 'jst' format in order to keep Rails from trying to use
  # the view for everything:
  #
  #   show.js.hbs # *not* show.hbs or show.html.hbs
  #
  module Controller
    extend ActiveSupport::Concern

    DEFAULT_HBS_TEMPLATE_PATH = 'app/assets/javascripts/templates'

    included do
      Mime::Type.register_alias 'text/html', :hbs
      Mime::Type.register_alias 'text/html', :handlebars

      self.responder = HandlebarsAssets::Responder

      def self.handlebars_templates(options = {})
        paths = options[:paths] || options[:path] || []
        Array(paths).reverse_each { |p| prepend_view_path(p) }
      end

      handlebars_templates path: DEFAULT_HBS_TEMPLATE_PATH
    end
  end
end
