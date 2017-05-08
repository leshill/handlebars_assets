module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register", :group => :all do |app|
      app.config.assets.configure do |sprockets_env|
        ::HandlebarsAssets::install(sprockets_env)
        if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3')
          sprockets_env.version += "-#{HandlebarsAssets::VERSION}" # so updating busts assets on old sprockets versions
        end
      end
    end
  end
end
