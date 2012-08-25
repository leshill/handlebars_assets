require 'test_helper'

module HandlebarsAssets
  class TiltHandlebarsTest < Test::Unit::TestCase
    include SprocketsScope

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
            return this.HandlebarsTemplates["#{template_name}"];
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

    def hbs_compiled_without_helper_opt(template_name, helper_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[\"#{template_name}\"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType=\"function\", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = \"\", stack1;
  buffer += \"By \";
  foundHelper = helpers.first_name;
  stack1 = foundHelper || depth0.first_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"first_name\", { hash: {} }); }
  buffer += escapeExpression(stack1) + \" \";
  foundHelper = helpers.last_name;
  stack1 = foundHelper || depth0.last_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"last_name\", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;}

  foundHelper = helpers.author;
  stack1 = foundHelper || depth0.author;
  stack2 = helpers['#{helper_name}'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
            return this.HandlebarsTemplates[\"#{template_name}\"];
          }).call(this);
END_EXPECTED
    end

    def hbs_compiled_with_helper_opt(template_name, helper_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[\"#{template_name}\"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType=\"function\", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = \"\", stack1;
  buffer += \"By \";
  stack1 = depth0.first_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"first_name\", { hash: {} }); }
  buffer += escapeExpression(stack1) + \" \";
  stack1 = depth0.last_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"last_name\", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;}

  stack1 = depth0.author;
  stack2 = helpers['#{helper_name}'];
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
            return this.HandlebarsTemplates[\"#{template_name}\"];
          }).call(this);
END_EXPECTED
    end

    def hbs_custom_compiled_without_helper_opt(template_name, helper_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[\"#{template_name}\"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType=\"function\", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression, blockHelperMissing=helpers.blockHelperMissing;

function program1(depth0,data) {
  
  var buffer = \"\", stack1;
  buffer += \"By \";
  foundHelper = helpers.first_name;
  stack1 = foundHelper || depth0.first_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"first_name\", { hash: {} }); }
  buffer += escapeExpression(stack1) + \" \";
  foundHelper = helpers.last_name;
  stack1 = foundHelper || depth0.last_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"last_name\", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;}

  foundHelper = helpers.author;
  stack1 = foundHelper || depth0.author;
  foundHelper = helpers.#{helper_name};
  stack2 = foundHelper || depth0.#{helper_name};
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  if(foundHelper && typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, tmp1); }
  else { stack1 = blockHelperMissing.call(depth0, stack2, stack1, tmp1); }
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
            return this.HandlebarsTemplates[\"#{template_name}\"];
          }).call(this);
END_EXPECTED
    end

    def hbs_custom_compiled_with_helper_opt(template_name, helper_name)
      <<END_EXPECTED
          (function() {
            this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
            this.HandlebarsTemplates[\"#{template_name}\"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var stack1, stack2, foundHelper, tmp1, self=this, functionType=\"function\", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression, blockHelperMissing=helpers.blockHelperMissing;

function program1(depth0,data) {
  
  var buffer = \"\", stack1;
  buffer += \"By \";
  stack1 = depth0.first_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"first_name\", { hash: {} }); }
  buffer += escapeExpression(stack1) + \" \";
  stack1 = depth0.last_name;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, \"last_name\", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;}

  stack1 = depth0.author;
  stack2 = depth0.#{helper_name};
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  if(foundHelper && typeof stack2 === functionType) { stack1 = stack2.call(depth0, stack1, tmp1); }
  else { stack1 = blockHelperMissing.call(depth0, stack2, stack1, tmp1); }
  if(stack1 || stack1 === 0) { return stack1; }
  else { return ''; }});
            return this.HandlebarsTemplates[\"#{template_name}\"];
          }).call(this);
END_EXPECTED
    end

    def hbs_compiled_template_namespace(template_name)
      <<END_EXPECTED
          (function() {
            this.JST || (this.JST = {});
            this.JST["#{template_name}"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


  buffer += "This is ";
  foundHelper = helpers.handlebars;
  stack1 = foundHelper || depth0.handlebars;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "handlebars", { hash: {} }); }
  buffer += escapeExpression(stack1);
  return buffer;});
            return this.JST["#{template_name}"];
          }).call(this);
END_EXPECTED
    end

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

    def test_without_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_without_known.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "{{#with author}}By {{first_name}} {{last_name}}{{/with}}" }

      assert_equal hbs_compiled_without_helper_opt('test_without_known', 'with'), template.render(scope, {})
    end

    def test_known_helpers_opt
      root = '/myapp/app/assets/templates'
      file = 'test_known.hbs'
      scope = make_scope root, file

      HandlebarsAssets::Config.known_helpers_only = true

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "{{#with author}}By {{first_name}} {{last_name}}{{/with}}" }

      assert_equal hbs_compiled_with_helper_opt('test_known', 'with'), template.render(scope, {})
    end

    def test_with_custom_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_helper.hbs'
      scope = make_scope root, file

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}" }

      assert_equal hbs_custom_compiled_without_helper_opt('test_custom_helper', 'custom'), template.render(scope, {})
    end

    def test_with_custom_known_helpers
      root = '/myapp/app/assets/templates'
      file = 'test_custom_known_helper.hbs'
      scope = make_scope root, file

      HandlebarsAssets::Config.known_helpers_only = true
      HandlebarsAssets::Config.known_helpers = %w(custom)

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "{{#custom author}}By {{first_name}} {{last_name}}{{/custom}}" }

      assert_equal hbs_custom_compiled_with_helper_opt('test_custom_known_helper', 'custom'), template.render(scope, {})
    end

    def test_template_namespace
      root = '/myapp/app/assets/javascripts'
      file = 'test_template_namespace.hbs'
      scope = make_scope root, file

      HandlebarsAssets::Config.template_namespace = 'JST'

      template = HandlebarsAssets::TiltHandlebars.new(scope.pathname.to_s) { "This is {{handlebars}}" }

      assert_equal hbs_compiled_template_namespace('test_template_namespace'), template.render(scope, {})
    end

  end
end
