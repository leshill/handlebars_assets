module HandlebarsAssets
  class Engine < ::Rails::Engine
    config.before_initialize do |app|
      Sprockets.register_engine('.hbs', TiltHandlebars)
      Sprockets.register_engine('.handlebars', TiltHandlebars)
      Sprockets.register_engine('.hamlbars', TiltHandlebars) if HandlebarsAssets::Config.haml_available?
      Sprockets.register_engine('.slimbars', TiltHandlebars) if HandlebarsAssets::Config.slim_available?
    end
  end
end
