require 'test_helper'

module HandlebarsAssets
  class CompilingTest < Test::Unit::TestCase

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_custom_handlebars
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.compiler_path = File.expand_path '../../edge', __FILE__

      compiled = Handlebars.precompile(source, HandlebarsAssets::Config.options)
      assert_match /PRECOMPILE CALLED/, compiled
    end
  end
end
