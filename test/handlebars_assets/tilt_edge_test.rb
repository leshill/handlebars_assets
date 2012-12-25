require 'test_helper'

module HandlebarsAssets
  class TiltEdgeTest < Test::Unit::TestCase
    include SprocketsScope
    include CompilerSupport

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_edge_compile
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.compiler_path = File.expand_path '../../edge', __FILE__

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_render', source), template.render(scope, {})
    end
  end
end
