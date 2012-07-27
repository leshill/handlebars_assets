module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'
  #
  # Or in a block:
  #
  # HandlebarsAssets::Config.configure do |config|
  #   known_helpers_only = true
  #   path_prefix = 'app/templates'
  # end

  module Config
    extend self

    def configure
      yield self
    end

    attr_writer :known_helpers_only, :path_prefix

    def known_helpers_only
      @known_helpers_only || false
    end

    def options
      options = {}
      options[:knownHelpersOnly] = true if known_helpers_only
      options
    end

    def path_prefix
      @path_prefix ||= 'templates'
    end

  end
end
