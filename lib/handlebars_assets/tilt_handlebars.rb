require 'tilt'

module HandlebarsAssets
  class TiltHandlebars < Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      template_path = TemplatePath.new(scope)

      compiled_hbs = Handlebars.precompile(data, HandlebarsAssets::Config.options)

      template_namespace = HandlebarsAssets::Config.template_namespace

      if template_path.is_partial?
        <<-PARTIAL
          (function() {
            Handlebars.registerPartial(#{template_path.name}, Handlebars.template(#{compiled_hbs}));
          }).call(this);
        PARTIAL
      else
        <<-TEMPLATE
          (function() {
            this.#{template_namespace} || (this.#{template_namespace} = {});
            this.#{template_namespace}[#{template_path.name}] = Handlebars.template(#{compiled_hbs});
            return this.#{template_namespace}[#{template_path.name}];
          }).call(this);
        TEMPLATE
      end
    end

    protected

    def prepare; end

    class TemplatePath
      def initialize(scope)
        self.template_path = scope.logical_path
      end

      def is_partial?
        template_path.gsub(%r{.*/}, '').start_with?('_')
      end

      def name
        is_partial? ? partial_name : template_name
      end

      private

      attr_accessor :template_path

      def forced_underscore_name
        '_' + relative_path
      end

      def relative_path
        template_path.gsub(/^#{HandlebarsAssets::Config.path_prefix}\/(.*)$/i, "\\1")
      end

      def partial_name
        forced_underscore_name.gsub(/\//, '_').gsub(/__/, '_').dump
      end

      def template_name
        relative_path.dump
      end
    end
  end
end
