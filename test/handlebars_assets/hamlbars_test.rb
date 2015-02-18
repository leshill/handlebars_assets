require 'test_helper'

module HandlebarsAssets
  class HamlbarsTest < ::Minitest::Test
    include SprocketsScope
    include CompilerSupport

    def compile_haml(source)
      (Haml::Engine.new(source, HandlebarsAssets::Config.haml_options).render).chomp
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

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_render', compile_haml(source)), template.render(scope, {})
    end
  end
end
