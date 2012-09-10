module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'
  module Config
    extend self

    attr_writer :compiler, :compiler_path, :known_helpers, :known_helpers_only, :options, :path_prefix, :template_namespace

    def compiler
      @compiler || 'handlebars.js'
    end

    def compiler_path
      @compiler_path || HandlebarsAssets.path
    end

    def known_helpers
      @known_helpers || []
    end

    def known_helpers_only
      @known_helpers_only || false
    end

    def options
      @options ||= generate_options
    end

    def path_prefix
      @path_prefix || 'templates'
    end

    def template_namespace
      @template_namespace || 'HandlebarsTemplates'
    end

    private

    def generate_known_helpers_hash
      known_helpers.inject({}) do |hash, helper|
        hash[helper] = true
      end
    end

    def generate_options
      options = {}
      options[:knownHelpersOnly] = true if known_helpers_only
      options[:knownHelpers] = generate_known_helpers_hash if known_helpers.any?
      options
    end

  end
end
