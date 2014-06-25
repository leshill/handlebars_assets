require 'handlebars_assets/version'

module HandlebarsAssets
  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:HandlebarsTemplate, 'handlebars_assets/handlebars_template')

  PATH = File.expand_path('../../vendor/assets/javascripts', __FILE__)

  def self.path
    PATH
  end

  def self.configure
    yield Config
  end

  def self.register_extensions(sprockets_environment)
      Config.handlebars_extensions.each do |ext|
        sprockets_environment.register_engine(ext, HandlebarsTemplate)
      end
      if Config.haml_enabled? && Config.haml_available?
        Config.hamlbars_extensions.each do |ext|
          sprockets_environment.register_engine(ext, HandlebarsTemplate)
        end
      end
      if Config.slim_enabled? && Config.slim_available?
        Config.slimbars_extensions.each do |ext|
          sprockets_environment.register_engine(ext, HandlebarsTemplate)
        end
      end
  end

end

# Register the engine (which will register extension in the app)
# or ASSUME using sprockets
if defined?(Rails)
  require 'handlebars_assets/engine'
else
  require 'sprockets'
  ::HandlebarsAssets.register_extensions(Sprockets)
end
