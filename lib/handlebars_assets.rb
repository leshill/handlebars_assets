require "handlebars_assets/version"

module HandlebarsAssets
  PATH = File.expand_path("../../vendor/assets/javascripts", __FILE__)

  def self.path
    PATH
  end

  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:TiltHandlebars, 'handlebars_assets/tilt_handlebars')

  if defined?(Rails) && defined?(::Rails::Engine)
    require 'handlebars_assets/engine'
  else
    require 'sprockets'
    Sprockets.register_engine '.hbs', TiltHandlebars
    Sprockets.register_engine '.handlebars', TiltHandlebars
  end
end
