require 'handlebars_assets/version'

module HandlebarsAssets
  autoload(:Config, 'handlebars_assets/config')
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:HandlebarsTemplate, 'handlebars_assets/handlebars_template')
  autoload(:HandlebarsProcessor, 'handlebars_assets/handlebars_template')

  PATH = File.expand_path('../../vendor/assets/javascripts', __FILE__)

  def self.path
    PATH
  end

  def self.configure
    yield Config
  end

  def self.install(env) # sprockets environment
    extension_sets = []
    extension_sets << Config.handlebars_extensions # default extensions
    extension_sets << Config.slimbars_extensions if Config.slim_enabled? && Config.slim_available?
    extension_sets << Config.handlebars_extensions if Config.haml_enabled? && Config.haml_available?

    # Sprockets 4
    if env.respond_to?(:register_transformer)
      extension_sets.each do |exts|
        env.register_mime_type 'text/x-handlebars-template', extensions: exts
      end

      env.register_transformer 'text/x-handlebars-template', 'application/javascript', HandlebarsProcessor
    end

    # Sprockets 2 & 3
    if env.respond_to?(:register_engine)
      extension_sets.each do |exts|
        exts.each do |ext|
          args = [ext, HandlebarsProcessor]
          args << { mime_type: 'text/x-handlebars-template', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
          env.register_engine(*args)
        end
      end
    end

    true
  end
end

# Register the engine (which will register extension in the app)
# or ASSUME using sprockets
if defined?(Rails)
  require 'handlebars_assets/engine'
else
  require 'sprockets'
  ::HandlebarsAssets.install(Sprockets)
end
