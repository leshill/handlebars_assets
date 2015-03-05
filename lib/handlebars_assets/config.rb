module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'

  module Config
    extend self

    attr_writer :compiler, :compiler_path, :ember, :multiple_frameworks,
      :haml_options, :known_helpers, :known_helpers_only, :options,
      :patch_files, :patch_path, :path_prefix, :slim_options, :template_namespace,
      :precompile, :haml_enabled, :slim_enabled,
      :handlebars_extensions, :hamlbars_extensions, :slimbars_extensions,
      :amd, :handlebars_amd_path, :amd_with_template_namespace,
      :chomp_underscore_for_partials

    def compiler
      @compiler || 'handlebars.js'
    end

    def self.configure
      yield self
    end

    def compiler_path
      @compiler_path || HandlebarsAssets.path
    end

    def ember?
      @ember || false
    end

    def multiple_frameworks?
      @multiple_frameworks
    end

    def haml_available?
      defined? ::Haml::Engine
    end

    def haml_enabled?
      @haml_enabled = true if @haml_enabled.nil?
      @haml_enabled
    end

    def haml_options
      @haml_options || {}
    end

    def slim_available?
      defined? ::Slim::Engine
    end

    def slim_enabled?
      @slim_enabled = true if @slim_enabled.nil?
      @slim_enabled
    end

    def slim_options
      @slim_options || {}
    end

    def known_helpers
      @known_helpers || []
    end

    def known_helpers_only
      @known_helpers_only = false if @known_helpers_only.nil?
      @known_helpers_only
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
      @path_prefix ||= 'templates'
    end

    def precompile
      @precompile = true if @precompile.nil?
      @precompile
    end

    def template_namespace
      @template_namespace || 'HandlebarsTemplates'
    end

    def handlebars_extensions
      @hbs_extensions ||= ['.hbs', '.handlebars']
    end

    def hamlbars_extensions
      @hamlbars_extensions ||= ['.hamlbars']
    end

    def slimbars_extensions
      @slimbars_extensions ||= ['.slimbars']
    end

    def ember_extensions
      @ember_extensions ||= ['.ember']
    end

    def amd?
      @amd || false
    end

    # indicate whether the template should
    # be added to the global template namespace
    def amd_with_template_namespace
      @amd_with_template_namespace || false
    end

    # path specified by the require.js paths
    # during configuration for the handlebars
    def handlebars_amd_path
      @handlebars_amd_path || 'handlebars'
    end

    # Indicate if leading underscore should be allowed
    # when creating partial definition.
    # Allows compatibility with handlebars-rails
    # https://github.com/cowboyd/handlebars-rails/blob/f73a2d11df8aa2c21d335b8f04a8c5b59ae6a790/lib/handlebars-rails/tilt.rb#L18
    def chomp_underscore_for_partials?
      @chomp_underscore_for_partials || false
    end

    private

    def generate_known_helpers_hash
      known_helpers.inject({}) do |hash, helper|
        hash[helper] = true
        hash
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
