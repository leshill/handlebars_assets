require 'tilt'

module HandlebarsAssets
  module Unindent
    # http://bit.ly/aze9FV
    # Strip leading whitespace from each line that is the same as the
    # amount of whitespace on the first line of the string.
    # Leaves _additional_ indentation on later lines intact.
    def unindent(heredoc)
      heredoc.gsub /^#{heredoc[/\A\s*/]}/, ''
    end
  end

  class TiltHandlebars < Tilt::Template

    include Unindent

    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      template_path = TemplatePath.new(scope)

      source = if template_path.is_haml?
                 Haml::Engine.new(data, HandlebarsAssets::Config.haml_options).render
               elsif template_path.is_slim?
                 Slim::Template.new(HandlebarsAssets::Config.slim_options) { data }.render
               else
                 data
               end

      if HandlebarsAssets::Config.ember?
        "window.Ember.TEMPLATES[#{template_path.name}] = Ember.Handlebars.compile(#{MultiJson.dump source});"
      else
        compiled_hbs = Handlebars.precompile(source, HandlebarsAssets::Config.options)

        template_namespace = HandlebarsAssets::Config.template_namespace

        if template_path.is_partial?
          unindent <<-PARTIAL
            (function() {
              Handlebars.registerPartial(#{template_path.name}, Handlebars.template(#{compiled_hbs}));
            }).call(this);
          PARTIAL
        else
          unindent <<-TEMPLATE
            (function() {
              this.#{template_namespace} || (this.#{template_namespace} = {});
              this.#{template_namespace}[#{template_path.name}] = Handlebars.template(#{compiled_hbs});
              return this.#{template_namespace}[#{template_path.name}];
            }).call(this);
          TEMPLATE
        end
      end
    end

    def initialize_engine
      begin
        require 'haml'
      rescue LoadError
        # haml not available
      end
      begin
        require 'slim'
      rescue LoadError
        # slim not available
      end
    end

    protected

    def prepare; end

    class TemplatePath
      def initialize(scope)
        self.full_path = scope.pathname
        self.template_path = scope.logical_path
      end

      def is_haml?
        full_path.to_s.end_with?('.hamlbars')
      end

      def is_slim?
        full_path.to_s.end_with?('.slimbars')
      end

      def is_partial?
        template_path.gsub(%r{.*/}, '').start_with?('_')
      end

      def name
        template_name
      end

      private

      attr_accessor :full_path, :template_path

      def relative_path
        template_path.gsub(/^#{HandlebarsAssets::Config.path_prefix}\/(.*)$/i, "\\1")
      end

      def template_name
        relative_path.dump
      end
    end
  end
end
