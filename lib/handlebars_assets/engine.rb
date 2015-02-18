module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register", :group => :all do |app|
      ::HandlebarsAssets::register_extensions(Sprockets)
      ::HandlebarsAssets::add_to_asset_versioning(Sprockets)
    end
  end
end
