require 'test_helper'

module HandlebarsAssets
  class TiltHandlebarsTest < Test::Unit::TestCase
    include CompilerSupport
    include SprocketsScope

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_render
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_render', source), template.render(scope, {})
    end

    # Sprockets does not add nested root paths (i.e.
    # app/assets/javascripts/templates is rooted at app/assets/javascripts)
    def test_template_misnaming
      root = '/myapp/app/assets/javascripts'
      file = 'templates/test_template_misnaming.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_template_misnaming', source), template.render(scope, {})
    end

    def test_path_prefix
      root = '/myapp/app/assets/javascripts'
      file = 'app/templates/test_path_prefix.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.path_prefix = 'app/templates'

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_path_prefix', source), template.render(scope, {})
    end

    def test_underscore_partials
      root = '/myapp/app/assets/javascripts'
      file1 = 'app/templates/_test_underscore.hbs'
      scope1 = make_scope root, file1
      file2 = 'app/templates/some/thing/_test_underscore.hbs'
      scope2 = make_scope root, file2
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.path_prefix = 'app/templates'

      template1 = HandlebarsAssets::TiltHandlebars.new(scope1.pathname.to_s) { source }

      assert_equal hbs_compiled_partial('_test_underscore', source), template1.render(scope1, {})

      template2 = HandlebarsAssets::TiltHandlebars.new(scope2.pathname.to_s) { source }

      assert_equal hbs_compiled_partial('some/thing/_test_underscore', source), template2.render(scope2, {})
    end

    def test_without_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_without_known.hbs'
      scope = make_scope root, file
      source = "{{#with author}}By {{first_name}} {{last_name}}{{/with}}"

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_without_known', source), template.render(scope, {})
    end

    def test_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_known.hbs'
      scope = make_scope root, file
      source = "{{#with author}}By {{first_name}} {{last_name}}{{/with}}"

      HandlebarsAssets::Config.known_helpers_only = true

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_known', source), template.render(scope, {})
    end

    def test_with_custom_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_helper.hbs'
      scope = make_scope root, file
      source = "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}"

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_custom_helper', source), template.render(scope, {})
    end

    def test_with_custom_known_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_known_helper.hbs'
      scope = make_scope root, file
      source = "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}"

      HandlebarsAssets::Config.known_helpers_only = true
      HandlebarsAssets::Config.known_helpers = %w(custom)

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_custom_known_helper', source), template.render(scope, {})
    end

    def test_template_namespace
      root = '/myapp/app/assets/javascripts'
      file = 'test_template_namespace.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.template_namespace = 'JST'

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_template_namespace', source), template.render(scope, {})
    end

    def test_ember_render
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.ember = true
      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { source }

      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("This is {{handlebars}}");};
      assert_equal expected_compiled, template.render(scope, {})
    end
  end
end
