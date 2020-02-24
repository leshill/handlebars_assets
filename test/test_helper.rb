require 'handlebars_assets'
require 'handlebars_assets/config'
require 'handlebars_assets/handlebars_template'
require 'handlebars_assets/handlebars'

require 'minitest/autorun'

module SprocketsScope
  # Try to act like sprockets.
  def make_scope(root, file)
    Class.new do
      define_method(:logical_path) { pathname.to_s.gsub(root + '/', '').gsub(/\..*/, '') }

      define_method(:pathname) { Pathname.new(root) + file }

      define_method(:root_path) { root }
    end.new
  end
end

module CompilerSupport
  include HandlebarsAssets::Unindent

  def compile_hbs(source)
    compiler_src = Pathname(HandlebarsAssets::Config.compiler_path).join(HandlebarsAssets::Config.compiler).read
    ExecJS.compile("var window = {}; " + compiler_src).call('Handlebars.precompile', source, HandlebarsAssets::Config.options)
  end

  def hbs_compiled(template_name, source)
    compiled_hbs = compile_hbs(source).strip
    template_namespace = HandlebarsAssets::Config.template_namespace

    <<-END_EXPECTED
(function() {
  this.#{template_namespace} || (this.#{template_namespace} = {});
  this.#{template_namespace}[#{template_name.dump}] = Handlebars.template(#{compiled_hbs});
  return this.#{template_namespace}[#{template_name.dump}];
}).call(this);
    END_EXPECTED
  end

  def hbs_compiled_partial(partial_name, source)
    compiled_hbs = compile_hbs(source)

    <<-END_EXPECTED
(function() {
  Handlebars.registerPartial(#{partial_name.dump}, Handlebars.template(#{compiled_hbs}));
}).call(this);
    END_EXPECTED
  end
end

module HandlebarsAssets
  module Config
    extend self

    def reset!
      @chomp_underscore_for_partials = nil
      @compiler = nil
      @compiler_path = nil
      @haml_options = nil
      @known_helpers = nil
      @known_helpers_only = nil
      @options = nil
      @patch_files = nil
      @patch_path = nil
      @path_prefix = nil
      @template_namespace = nil
      @ember = nil
    end

  end

  class Handlebars

    def self.reset!
      @context = nil
      @source = nil
      @patch_path = nil
      @path = nil
      @assets_path = nil
    end

  end
end
