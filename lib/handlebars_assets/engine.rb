module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    if Gem::Version.new(Rails.version) >= Gem::Version.new('4')
      initializer "handlebars_assets.assets.register", :group => :all do |app|
        app.config.assets.configure do |sprockets_env|
          ::HandlebarsAssets::register_extensions(sprockets_env)
          if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3')
            ::HandlebarsAssets::add_to_asset_versioning(sprockets_env)
          end
        end
      end
    else
      config.before_initialize do
        ::HandlebarsAssets::register_extensions(Sprockets)
      end
    end
  end
end
