require 'test_helper'

module HandlebarsAssets
  class TiltHandlebarsTest < Test::Unit::TestCase
    include SprocketsScope

    def hbs_edge_compiled(template_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[\"#{template_name}\"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = \"\", stack1, foundHelper, functionType=\"function\", escapeExpression=this.escapeExpression;


  buffer += \"This is \";
  foundHelper = helpers.handlebars;
  if (foundHelper) { stack1 = foundHelper.call(depth0, {hash:{}}); }
  else { stack1 = depth0.handlebars; stack1 = typeof stack1 === functionType ? stack1() : stack1; }
  buffer += escapeExpression(stack1);
  return buffer;});
            return this.HandlebarsTemplates[\"#{template_name}\"];
          }).call(this);
END_EXPECTED
    end

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def test_edge_compile
      root = '/myapp/app/assets/templates'
      file = 'test_render.hbs'
      scope = make_scope root, file

      HandlebarsAssets::Config.compiler_path = File.expand_path '../../edge', __FILE__

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_edge_compiled('test_render'), template.render(scope, {})
    end
  end
end
