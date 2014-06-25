require 'action_view/template/handlers/hbs'

module HandlebarsAssets
  # NOTE: must be an engine because we are including assets in the gem
  class Engine < ::Rails::Engine
    initializer "handlebars_assets.assets.register" do |app|
      ::HandlebarsAssets::register_extensions(app.assets)
    end

    initializer 'handlebars.register_template_handler' do
      ActiveSupport.on_load(:action_view) do
        [:hbs, :handlebars].each do |ext|
          ActionView::Template.register_template_handler(ext, ActionView::Template::Handlers::HBS)
        end
      end
    end
  end
end
