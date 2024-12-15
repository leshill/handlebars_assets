# frozen_string_literal: true

require 'handlebars_assets/version'

module HandlebarsAssets
  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:HandlebarsTemplate, 'handlebars_assets/handlebars_template')
  autoload(:HandlebarsProcessor, 'handlebars_assets/handlebars_template')

  PATH = File.expand_path('../vendor/assets/javascripts', __dir__)

  def self.path
    PATH
  end

  def self.configure
    yield Config
  end

  def self.register_extensions(sprockets_environment)
    extensions = Config.handlebars_extensions
    extensions += Config.slimbars_extensions if Config.slim_enabled? && Config.slim_available?
    extensions += Config.hamlbars_extensions if Config.haml_enabled? && Config.haml_available?
    mime_type = 'text/x-handlebars-template'
    sprockets_environment.register_mime_type mime_type, extensions: extensions
    sprockets_environment.register_transformer mime_type, 'application/javascript', HandlebarsProcessor
    sprockets_environment.register_transformer_suffix mime_type, 'application/\2+ruby', '.erb',
                                                      Sprockets::ERBProcessor
  end

  def self.add_to_asset_versioning(sprockets_environment)
    sprockets_environment.version += "-#{HandlebarsAssets::VERSION}"
  end
end

# Register the engine (which will register extension in the app)
# or ASSUME using sprockets
if defined?(Rails)
  require 'handlebars_assets/engine'
else
  require 'sprockets'
  HandlebarsAssets.register_extensions(Sprockets)
end
