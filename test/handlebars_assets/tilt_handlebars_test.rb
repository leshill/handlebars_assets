require 'test_helper'

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

    def hbs_compiled
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates["x11"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "This is ";
  foundHelper = helpers.handlebars;
  stack1 = foundHelper || depth0.handlebars;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "handlebars", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;});
            return HandlebarsTemplates["x11"];
          }).call(this);
END_EXPECTED
    end

    def test_render
      root = '/myapp/app/assets/templates'
      file = 'x11.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled, template.render(scope, {})
    end

    # Sprockets does not add nested root paths (i.e.
    # app/assets/javascripts/templates is rooted at app/assets/javascripts)
    def test_template_misnaming
      root = '/myapp/app/assets/javascripts'
      file = 'templates/x11.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled, template.render(scope, {})
    end
  end
end
