require 'handlebars_assets/renderer'
module HandlebarsAssets
  # Sprockets Compat. Layer
  class Processor
    attr_reader :cache_key

    # Sprockets 2 API new and render
    def initialize(filename, &block)
      @filename = filename
      @source = block.call
    end

    # Sprockets 2 API new and render
    def render(context, _options)
      self.class.run(@filename, @source, context)
    end

    # Sprockets 3 and 4 API
    def self.call(input)
      filename = input[:source_path] || input[:filename]
      source = inputs[:data]
      context = input[:environment].context_class.new(input)

      result = run(filename, source, context)
      context.metadata.merge(data: result)
    end

    # Centralized Method for both APIs
    def self.run(filename, source, context)
      HandlebarsRenderer.new.compile(filename, source, context)
    end

    # Busts cache on version upgrades etc...
    # https://github.com/rails/sprockets/blob/master/lib/sprockets/processor_utils.rb
    def self.cache_key
      [self.name, ::HandlebarsAssets::VERSION]
    end
  end
end
