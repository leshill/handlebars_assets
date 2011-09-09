# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module HandlebarsAssets
  class Handlebars
    class << self
      def precompile(*args)
        context.call('Handlebars.precompile', *args)
      end

      private
      def context
        @context ||= ExecJS.compile(source)
      end

      def source
        @source ||= path.read
      end

      def path
        @path ||= assets_path.join('javascripts', 'handlebars.js')
      end

      def assets_path
        @assets_path ||= Pathname(__FILE__).dirname.join('..','..','vendor','assets')
      end
    end
  end
end
