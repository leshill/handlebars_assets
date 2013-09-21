require 'handlebars_assets/version'
require 'sprockets'

module HandlebarsAssets
  PATH = File.expand_path('../../vendor/assets/javascripts', __FILE__)

  def self.path
    PATH
  end

  def register_extensions(sprockets_environment)
      sprockets_environment.register_engine('.hbs', TiltHandlebars)
      sprockets_environment.register_engine('.handlebars', TiltHandlebars)
      sprockets_environment.register_engine('.hamlbars', TiltHandlebars) if HandlebarsAssets::Config.haml_available?
      sprockets_environment.register_engine('.slimbars', TiltHandlebars) if HandlebarsAssets::Config.slim_available?
  end

  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:TiltHandlebars, 'handlebars_assets/tilt_handlebars')
end

if defined?(Rails)
  require 'handlebar_assets/railtie'
else
  register_extensions(Sprockets)
end
