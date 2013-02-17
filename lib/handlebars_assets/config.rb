module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'
  module Config
    extend self

    attr_writer :compiler, :compiler_path, :ember, :haml_options,
      :known_helpers, :known_helpers_only, :options, :patch_files,
      :patch_path, :path_prefix, :slim_options, :template_namespace

    def compiler
      @compiler || 'handlebars.js'
    end

    def compiler_path
      @compiler_path || HandlebarsAssets.path
    end

    def ember?
      @ember
    end

    def haml_available?
      defined? ::Haml::Engine
    end

    def haml_options
      @haml_options || {}
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

    def patch_files
      Array(@patch_files)
    end

    def patch_path
      @patch_path ||= compiler_path
    end

    def path_prefix
      @path_prefix || 'templates'
    end

    def slim_available?
      defined? ::Slim::Engine
    end

    def slim_options
      @slim_options || {}
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
      options = @options || {}
      options[:knownHelpersOnly] = true if known_helpers_only
      options[:knownHelpers] = generate_known_helpers_hash if known_helpers.any?
      options
    end

  end
end
