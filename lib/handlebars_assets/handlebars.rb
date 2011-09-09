# Based on https://github.com/cowboyd/handlebars.rb
module HandlebarsAssets
  class Handlebars
    class << self
      def precompile(*args)
        context.call('Handlebars.precompile', *args)
      end

      def context
        @context ||= Loader.new.load_context
      end
    end
  end
end
