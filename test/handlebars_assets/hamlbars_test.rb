require 'test_helper'

module HandlebarsAssets
  class HamlbarsTest < Test::Unit::TestCase
    include SprocketsScope
    include Unindent

    def expected_haml_compiled(source)
      Haml::Engine.new(source, HandlebarsAssets::Config.haml_options).render
    end

    def expected_hbs_compiled(source)
      compiler_src = Pathname(HandlebarsAssets::Config.compiler_path).join(HandlebarsAssets::Config.compiler).read
      ExecJS.compile(compiler_src).call('Handlebars.precompile', source, HandlebarsAssets::Config.options)
    end

    def haml_compiled(template_name, source)
      compiled_haml = expected_haml_compiled(source)
      compiled_hbs = expected_hbs_compiled(compiled_haml)
      template_namespace = HandlebarsAssets::Config.template_namespace

      unindent <<END_EXPECTED
          (function() {
            this.#{template_namespace} || (this.#{template_namespace} = {});
            this.#{template_namespace}[#{template_name.dump}] = Handlebars.template(#{compiled_hbs});
            return this.#{template_namespace}[#{template_name.dump}];
          }).call(this);
END_EXPECTED
    end

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_render_haml
      root = '/myapp/app/assets/templates'
      file = 'test_render.hamlbars'
      scope = make_scope root, file
      source = "%p This is {{handlebars}}"

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal haml_compiled('test_render', source), template.render(scope, {})
    end
  end
end
