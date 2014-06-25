require 'test_helper'

module HandlebarsAssets
  class HandlebarsTemplateTest < Test::Unit::TestCase
    include CompilerSupport
    include SprocketsScope

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def compile_haml(source)
      Haml::Engine.new(source, HandlebarsAssets::Config.haml_options).render
    end

    def compile_slim(source)
      Slim::Template.new(HandlebarsAssets::Config.slim_options) { source }.render
    end

    def test_render
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_render', source), template.render(scope, {})
    end

    # Sprockets does not add nested root paths (i.e.
    # app/assets/javascripts/templates is rooted at app/assets/javascripts)
    def test_template_misnaming
      root = '/myapp/app/assets/javascripts'
      file = 'templates/test_template_misnaming.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_template_misnaming', source), template.render(scope, {})
    end

    def test_path_prefix
      root = '/myapp/app/assets/javascripts'
      file = 'app/templates/test_path_prefix.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.path_prefix = 'app/templates'

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

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

      template1 = HandlebarsAssets::HandlebarsTemplate.new(scope1.pathname.to_s) { source }

      assert_equal hbs_compiled_partial('_test_underscore', source), template1.render(scope1, {})

      template2 = HandlebarsAssets::HandlebarsTemplate.new(scope2.pathname.to_s) { source }

      assert_equal hbs_compiled_partial('some/thing/_test_underscore', source), template2.render(scope2, {})
    end

    def test_without_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_without_known.hbs'
      scope = make_scope root, file
      source = "{{#with author}}By {{first_name}} {{last_name}}{{/with}}"

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_without_known', source), template.render(scope, {})
    end

    def test_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_known.hbs'
      scope = make_scope root, file
      source = "{{#with author}}By {{first_name}} {{last_name}}{{/with}}"

      HandlebarsAssets::Config.known_helpers_only = true

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_known', source), template.render(scope, {})
    end

    def test_with_custom_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_helper.hbs'
      scope = make_scope root, file
      source = "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}"

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_custom_helper', source), template.render(scope, {})
    end

    def test_with_custom_known_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_known_helper.hbs'
      scope = make_scope root, file
      source = "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}"

      HandlebarsAssets::Config.known_helpers_only = true
      HandlebarsAssets::Config.known_helpers = %w(custom)

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_custom_known_helper', source), template.render(scope, {})
    end

    def test_template_namespace
      root = '/myapp/app/assets/javascripts/templates'
      file = 'test_template_namespace.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.template_namespace = 'JST'

      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      assert_equal hbs_compiled('test_template_namespace', source), template.render(scope, {})
    end

    def test_ember_render
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file
      source = "This is {{handlebars}}"

      HandlebarsAssets::Config.ember = true
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }

      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("This is {{handlebars}}");};
      assert_equal expected_compiled, template.render(scope, {})
    end

    def test_multiple_frameworks_with_ember_render
      root = '/myapp/app/assets/templates'
      non_ember = 'test_render.hbs'
      non_ember_but_with_ember = 'test_member.hbs'
      ember_ext_no_hbs = 'test_render.ember'
      ember_ext = 'test_render.ember.hbs'
      ember_with_haml = 'test_render.ember.hamlbars'
      ember_with_slim = 'test_render.ember.slimbars'
      ember_ext_with_erb = 'test_render.ember.hbs.erb'

      HandlebarsAssets::Config.ember = true
      HandlebarsAssets::Config.multiple_frameworks = true

      # File without ember extension should compile to default namespace
      scope = make_scope root, non_ember
      source = "This is {{handlebars}}"
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      assert_equal hbs_compiled('test_render', source), template.render(scope, {})

      # File without ember extension but with ember in it should compile to default namespace
      scope = make_scope root, non_ember_but_with_ember
      source = "This is {{handlebars}}"
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      assert_equal hbs_compiled('test_member', source), template.render(scope, {})

      # File with ember extension should compile to ember specific namespace
      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("This is {{handlebars}}");};
      scope = make_scope root, ember_ext_no_hbs
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      assert_equal expected_compiled, template.render(scope, {})

      # File with ember and erb extension should compile to ember specific namespace
      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("This is {{handlebars}}");};
      scope = make_scope root, ember_ext_with_erb
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      assert_equal expected_compiled, template.render(scope, {})

      # File with ember.hbs extension should compile to ember specific namespace
      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("This is {{handlebars}}");};
      scope = make_scope root, ember_ext
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      assert_equal expected_compiled, template.render(scope, {})

      # File with ember.hamlbars extension should compile to ember specific namespace
      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("<p>This is {{handlebars}}</p>");};
      scope = make_scope root, ember_with_haml
      source = "%p This is {{handlebars}}"
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { compile_haml(source) }
      assert_equal expected_compiled, template.render(scope, {})

      # File with ember.slimbars extension should compile to ember specific namespace
      expected_compiled = %{window.Ember.TEMPLATES["test_render"] = Ember.Handlebars.compile("<p>This is {{handlebars}}</p>");};
      source = "p This is {{handlebars}}"
      scope = make_scope root, ember_with_slim
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { compile_slim(source) }
      assert_equal expected_compiled, template.render(scope, {})
    end
  end
end
