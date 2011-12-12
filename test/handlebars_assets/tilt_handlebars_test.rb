require 'test_helper'

module HandlebarsAssets
  class TiltHandlebarsTest < Test::Unit::TestCase
    def test_render
      # Try to act like sprockets.
      scope = Object.new
      class << scope
        def logical_path ; 'x11' ; end
      end
      template = HandlebarsAssets::TiltHandlebars.new('/myapp/app/assets/templates/x11.jst.hbs') { "This is {{handlebars}}" }
      assert_equal <<END_EXPECTED, template.render(scope, {})
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates["x11"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "This is ";
  stack1 = helpers.handlebars || depth0.handlebars;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "handlebars", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;});
            return HandlebarsTemplates["x11"];
          }).call(this);
END_EXPECTED
    end
  end
end
