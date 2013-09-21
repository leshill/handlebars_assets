module HandlebarsAssets
  class Railtie < ::Rails::Railtie
    initializer "sprockets.handlebars", :after => "sprockets.environment", :group => :all do |app|
      HandlebarsAssets.register_extensions(app.assets)
    end
  end
end
