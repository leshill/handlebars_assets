require 'tilt'

module HandlebarsAssets
  class TiltHandlebars < Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      self.template_path = scope.logical_path

      compiled_hbs = Handlebars.precompile(data)

      if is_partial?
        <<-PARTIAL
          (function() {
            Handlebars.registerPartial(#{partial_name}, Handlebars.template(#{compiled_hbs}));
          }).call(this);
        PARTIAL
      else
        <<-TEMPLATE
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[#{template_name}] = Handlebars.template(#{compiled_hbs});
            return HandlebarsTemplates[#{template_name}];
          }).call(this);
        TEMPLATE
      end
    end

    protected

    attr_accessor :template_path

    def forced_underscore_name
      '_' + relative_path
    end

    def is_partial?
      template_path.gsub(%r{.*/}, '').start_with?('_')
    end

    def prepare; end

    def partial_name
      forced_underscore_name.gsub(/\//, '_').gsub(/__/, '_').dump
    end

    def relative_path
      template_path.gsub(/^#{HandlebarsAssets::Config.path_prefix}\/(.*)$/i, "\\1")
    end

    def template_name
      relative_path.dump
    end
  end
end
