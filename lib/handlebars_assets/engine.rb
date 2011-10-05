module HandlebarsAssets
  class Engine < ::Rails::Engine
    initializer "sprockets.handlebars", :after => "sprockets.environment", :group => :assets do |app|
      next unless app.assets
      app.assets.register_engine('.hbs', TiltHandlebars)
    end
  end
end
