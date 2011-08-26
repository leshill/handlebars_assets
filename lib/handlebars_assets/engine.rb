module HandlebarsAssets
  class Engine < ::Rails::Engine
    initializer "sprockets.handlebars", after: "sprockets.environment" do |app|
      app.assets.register_engine('.hbs', TiltHandlebars)
    end
  end
end
