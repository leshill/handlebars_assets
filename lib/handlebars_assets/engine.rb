module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register", :group => :all do |app|
      app.config.assets.configure do |sprockets_env|
        ::HandlebarsAssets::register_extensions(sprockets_env)
        if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3')
          ::HandlebarsAssets::add_to_asset_versioning(sprockets_env)
        end
      end
    end
  end
end
