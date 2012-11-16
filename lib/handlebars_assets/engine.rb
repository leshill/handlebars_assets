module HandlebarsAssets
  class Engine < ::Rails::Engine
    initializer "sprockets.handlebars", :after => "sprockets.environment", :group => :all do |app|
      next unless app.assets
      app.assets.register_engine('.hbs', TiltHandlebars)
      app.assets.register_engine('.handlebars', TiltHandlebars)
      app.assets.register_engine('.hamlbars', TiltHandlebars) if HandlebarsAssets::Config.haml_available?
    end
  end
end
