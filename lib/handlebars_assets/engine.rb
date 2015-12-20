module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register", :group => :all do |app|
      ::HandlebarsAssets::register_extensions(app.assets)
      if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3')
        ::HandlebarsAssets::add_to_asset_versioning(app.assets)
      end
    end
  end
end
