require 'test_helper'

module HandlebarsAssets
  class SlimbarsTest < ::Minitest::Test
    include SprocketsScope
    include CompilerSupport

    def compile_slim(source)
      Slim::Template.new(HandlebarsAssets::Config.slim_options) { source }.render
    end

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_render_slim
      root = '/myapp/app/assets/templates'
      file = 'test_render.slimbars'
      scope = make_scope root, file
      source = "p This is {{handlebars}}"

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_render', compile_slim(source)), template.render(scope, {})
    end
  end
end
