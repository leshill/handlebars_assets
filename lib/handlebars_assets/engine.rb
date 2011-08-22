module HandlebarsAssets
  class Engine < ::Rails::Engine
    config.after_initialize do |app|
      app.assets.register_engine('.hbs', TiltHandlebars)
    end
  end
end
