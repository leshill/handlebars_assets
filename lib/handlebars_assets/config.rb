module HandlebarsAssets
  # Change config options in an initializer:
  #
  # HandlebarsAssets::Config.path_prefix = 'app/templates'
  #
  # Or in a block:
  #
  # HandlebarsAssets::Config.configure do |config|
  #   path_prefix = 'app/templates'
  # end

  module Config
    extend self

    def configure
      yield self
    end

    attr_writer :path_prefix

    def path_prefix
      @path_prefix ||= 'templates'
    end
  end
end
