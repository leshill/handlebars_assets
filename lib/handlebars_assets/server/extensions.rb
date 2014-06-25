module HandlebarsAssets
  module Server
    module Extensions
      def context_for(template, extra = '')
        tmpl = "var template = Handlebars.template(#{precompile(template)})"
        context = [runtime, extra, tmpl].join('; ')

        ExecJS.compile(context)
      end

      def render(template, *args)
        locals = args.last.is_a?(Hash) ? args.pop : {}
        extra = args.first.to_s
        context_for(template, extra).call('template', locals)
      end

      protected

      def runtime
        @runtime ||= runtime_path.read
      end

      def runtime_path
        @runtime_path ||= assets_path.join(HandlebarsAssets::Config.compiler_runtime)
      end
    end
  end
end

::HandlebarsAssets::Handlebars.send(:extend, HandlebarsAssets::Server::Extensions)
