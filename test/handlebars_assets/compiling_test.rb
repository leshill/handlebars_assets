require 'test_helper'

module HandlebarsAssets
  class CompilingTest < ::MiniTest::Test

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

    def test_patching_handlebars
      source = "This is {{nested.handlebars}}"

      HandlebarsAssets::Config.patch_path = File.expand_path '../../patch', __FILE__
      HandlebarsAssets::Config.patch_files = ['patch.js']

      compiled = Handlebars.precompile(source, HandlebarsAssets::Config.options)
      assert_match /CALLED PATCH/, compiled
    end
  end
end
