require 'tilt'

module HandlebarsAssets
  class TiltHandlebars < Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      name = basename(scope.logical_path)
      compiled_hbs = Handlebars.precompile(data)

      if name.start_with?('_')
        partial_name = name[1..-1].inspect
        <<-PARTIAL
          (function() {
            Handlebars.registerPartial(#{partial_name}, Handlebars.template(#{compiled_hbs}));
          }).call(this);
        PARTIAL
      else
        template_name = scope.logical_path.inspect
        <<-TEMPLATE
          function(context) {
            return HandlebarsTemplates[#{template_name}](context);
          };
          this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
          this.HandlebarsTemplates[#{template_name}] = Handlebars.template(#{compiled_hbs});
        TEMPLATE
      end
    end

    protected

    def basename(path)
      path.gsub(%r{.*/}, '')
    end

    def prepare; end
  end
end
