require 'action_view/template/handlers/hbs'

module HandlebarsAssets
  class Engine < ::Rails::Engine
    initializer "sprockets.handlebars", :after => "sprockets.environment", :group => :all do |app|
      next unless app.assets
      app.assets.register_engine('.hbs', TiltHandlebars)
      app.assets.register_engine('.handlebars', TiltHandlebars)
      app.assets.register_engine('.hamlbars', TiltHandlebars) if HandlebarsAssets::Config.haml_available?
      app.assets.register_engine('.slimbars', TiltHandlebars) if HandlebarsAssets::Config.slim_available?
    end

    initializer "handlebars.register_template_handler" do
      ActiveSupport.on_load(:action_view) do
        [:hbs, :handlebars].each do |ext|
          ActionView::Template.register_template_handler(ext, ActionView::Template::Handlers::HBS)
        end
      end
    end
    
  end
end
