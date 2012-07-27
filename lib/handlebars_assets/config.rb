module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'
  #
  # Or in a block:
  #
  # HandlebarsAssets::Config.configure do |config|
  #   known_helpers = [:view, 'timestamp']
  #   known_helpers_only = true
  #   path_prefix = 'app/templates'
  # end

  module Config
    extend self

    def configure
      yield self
    end

    attr_writer :known_helpers, :known_helpers_only, :path_prefix

    def known_helpers
      @known_helpers || []
    end

    def known_helpers_only
      @known_helpers_only || false
    end

    def options
      options = {}
      options[:knownHelpersOnly] = true if known_helpers_only
      options[:knownHelpers] = known_helpers_hash if known_helpers_hash.any?
      options
    end

    def path_prefix
      @path_prefix ||= 'templates'
    end

    private

    def generate_known_helpers_hash
      known_helpers.inject({}) do |hash, helper|
        hash[helper] = true
      end
    end

    def known_helpers_hash
      @known_helpers_hash ||= generate_known_helpers_hash
    end
  end
end
