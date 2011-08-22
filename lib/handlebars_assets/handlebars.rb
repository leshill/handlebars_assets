# Based on https://github.com/cowboyd/handlebars.rb
module HandlebarsAssets
  module Handlebars
    @loader = Loader.new

    module_function

    def precompile(*args)
      handlebars.precompile(*args)
    end

    def handlebars
      Handlebars.module_eval do
        @loader.require('handlebars')
      end
    end
  end
end
