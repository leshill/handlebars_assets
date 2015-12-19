module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register", :group => :all do |app|
      if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3')
        ::HandlebarsAssets::register_extensions(app.assets)
        app.assets.version += "#{::HandlebarsAssets::VERSION}"
      else
        ::HandlebarsAssets::register_transformers(config)
        config.assets.version += "#{::HandlebarsAssets::VERSION}"
      end
    end
  end
end
