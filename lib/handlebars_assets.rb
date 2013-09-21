require 'handlebars_assets/version'
require 'sprockets'

module HandlebarsAssets
  PATH = File.expand_path('../../vendor/assets/javascripts', __FILE__)

  def self.path
    PATH
  end

  def self.register_extensions(sprockets_environment)
      Sprockets.register_engine('.hbs', TiltHandlebars)
      Sprockets.register_engine('.handlebars', TiltHandlebars)
      Sprockets.register_engine('.hamlbars', TiltHandlebars) if HandlebarsAssets::Config.haml_available?
      Sprockets.register_engine('.slimbars', TiltHandlebars) if HandlebarsAssets::Config.slim_available?
  end

  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:TiltHandlebars, 'handlebars_assets/tilt_handlebars')
end

HandlebarsAssets.register_extensions(Sprockets)
require 'handlebars_assets/engine' if defined?(Rails)
