require 'handlebars_assets'
require 'handlebars_assets/config'
require 'handlebars_assets/tilt_handlebars'
require 'handlebars_assets/handlebars'

require 'test/unit'

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

module HandlebarsAssets
  module Config
    extend self

    def reset!
      @known_helpers = nil
      @known_helpers_only = nil
      @options = nil
      @path_prefix = nil
      @template_namespace = nil
    end

  end
end
