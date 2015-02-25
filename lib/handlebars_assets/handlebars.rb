# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module HandlebarsAssets
  class Handlebars
    class << self

      def precompile(*args)
        context.call('Handlebars.precompile', *args)
      end

      protected

      attr_writer :source

      def append_patch(patch_file)
        self.source += patch_source(patch_file)
      end

      def apply_patches_to_source
        if HandlebarsAssets::Config.patch_files.any?
          HandlebarsAssets::Config.patch_files.each do |patch_file|
            append_patch(patch_file)
          end
        end
        source
      end

      def context
        @context ||= ExecJS.compile(apply_patches_to_source)
      end

      def source
        @source ||= "if (!window) { var window = {}; }\n#{path.read}"
      end

      def patch_path
        @patch_path ||= Pathname(HandlebarsAssets::Config.patch_path)
      end

      def patch_source(patch_file)
        patch_path.join(patch_file).read
      end

      def path
        @path ||= assets_path.join(HandlebarsAssets::Config.compiler)
      end

      def assets_path
        @assets_path ||= Pathname(HandlebarsAssets::Config.compiler_path)
      end
    end
  end
end
