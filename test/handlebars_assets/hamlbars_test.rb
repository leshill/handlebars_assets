# frozen_string_literal: true

require 'test_helper'

module HandlebarsAssets
  class HamlbarsTest < ::Minitest::Test
    include SprocketsScope
    include CompilerSupport

    def compile_haml(source)
      if Haml::VERSION >= '6.0.0'
        (Haml::Template.new(HandlebarsAssets::Config.haml_options) { source }).render.chomp
      else
        Haml::Engine.new(source, HandlebarsAssets::Config.haml_options).render.chomp
      end
    end

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_render_haml
      root = '/myapp/app/assets/templates'
      file = 'test_render.hamlbars'
      scope = make_scope root, file
      source = '%p This is {{handlebars}}'

      rendered = HandlebarsAssets::HandlebarsProcessor.call(filename: scope.pathname.to_s, data: source)

      assert_equal hbs_compiled('test_render', compile_haml(source)), rendered
    end
  end
end
