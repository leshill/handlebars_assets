require 'test_helper'
require 'handlebars_assets/config'

module HandlebarsAssets
  class TiltHandlebarsTest < Test::Unit::TestCase
    # Try to act like sprockets.
    def make_scope(root, file)
      Class.new do
        define_method(:logical_path) { pathname.to_s.gsub(root + '/', '').gsub(/\..*/, '') }

        define_method(:pathname) { Pathname.new(root) + file }

        define_method(:root_path) { root }
      end.new
    end

    def hbs_compiled(template_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates["#{template_name}"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "This is ";
  foundHelper = helpers.handlebars;
  stack1 = foundHelper || depth0.handlebars;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "handlebars", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;});
            return HandlebarsTemplates["#{template_name}"];
          }).call(this);
END_EXPECTED
    end

    def hbs_compiled_partial(partial_name)
      <<END_EXPECTED
          (function() {
            Handlebars.registerPartial(\"#{partial_name}\", Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = \"\", stack1, foundHelper, self=this, functionType=\"function\", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += \"This is \";
  foundHelper = helpers.handlebars;
  stack1 = foundHelper || depth0.handlebars;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"handlebars\", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;}));
          }).call(this);
END_EXPECTED
    end

    def teardown
      HandlebarsAssets::Config.path_prefix = nil
    end

    def test_render
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled('test_render'), template.render(scope, {})
    end

    # Sprockets does not add nested root paths (i.e.
    # app/assets/javascripts/templates is rooted at app/assets/javascripts)
    def test_template_misnaming
      root = '/myapp/app/assets/javascripts'
      file = 'templates/test_template_misnaming.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled('test_template_misnaming'), template.render(scope, {})
    end

    def test_path_prefix
      root = '/myapp/app/assets/javascripts'
      file = 'app/templates/test_path_prefix.hbs'
      scope = make_scope root, file

      HandlebarsAssets::Config.path_prefix = 'app/templates'

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled('test_path_prefix'), template.render(scope, {})
    end

    def test_underscore_partials
      root = '/myapp/app/assets/javascripts'
      file1 = 'app/templates/_test_underscore.hbs'
      scope1 = make_scope root, file1
      file2 = 'app/templates/some/thing/_test_underscore.hbs'
      scope2 = make_scope root, file2

      HandlebarsAssets::Config.path_prefix = 'app/templates'

      template1 = HandlebarsAssets::TiltHandlebars.new(scope1.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled_partial('_test_underscore'), template1.render(scope1, {})

      template2 = HandlebarsAssets::TiltHandlebars.new(scope2.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled_partial('_some_thing_test_underscore'), template2.render(scope2, {})

    end
  end
end
