# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module HandlebarsAssets
  class Handlebars
    class << self
      def precompile(*args)
        context.call('Handlebars.precompile', *args)
      end

      def context_for(template, extra = "")
        ExecJS.compile("#{runtime}; #{extra}; var template = Handlebars.template(#{precompile(template)})")
      end

      def render(template, *args)
        locals = args.last.is_a?(Hash) ? args.pop : {}
        extra = args.first.to_s
        context_for(template, extra).call("template", locals)
      end

      private

      def context
        @context ||= ExecJS.compile(source)
      end

      def source
        @source ||= path.read
      end

      def runtime
        @runtime ||= runtime_path.read
      end

      def path
        @path ||= assets_path.join(HandlebarsAssets::Config.compiler)
      end

      def runtime_path
        @runtime_path ||= assets_path.join(HandlebarsAssets::Config.compiler_runtime)
      end

      def assets_path
        @assets_path ||= Pathname(HandlebarsAssets::Config.compiler_path)
      end
    end
  end
end
