require 'handlebars_assets'
require 'handlebars_assets/tilt_handlebars'
require 'handlebars_assets/handlebars'

require 'test/unit'

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
