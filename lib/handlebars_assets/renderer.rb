require 'json'

module HandlebarsAssets
  class Renderer
    def compile(filename, source, context)
      @template_path = TemplatePath.new(filename)

      # remove trailing \n on file, for some reason the directives pipeline adds this
      source.chomp!($/)

      preprocessed_source =
        if @template_path.is_haml?
          Haml::Engine.new(source, HandlebarsAssets::Config.haml_options).render
        elsif @template_path.is_slim?
          Slim::Template.new(HandlebarsAssets::Config.slim_options) { source }.render
        else
          source
        end

      # handle the case of multiple frameworks combined with ember
      # DEFER: use extension setup for ember
      if (HandlebarsAssets::Config.multiple_frameworks? && @template_path.is_ember?) ||
         (HandlebarsAssets::Config.ember? && !HandlebarsAssets::Config.multiple_frameworks?)
        compile_ember(preprocessed_source)
      else
        compile_default(preprocessed_source)
      end
    end

    protected

    def compile_ember(source)
      "window.Ember.TEMPLATES[#{@template_path.name}] = Ember.Handlebars.compile(#{JSON.dump(source)});"
    end

    def compile_default(source)
      # the compiled/sourced file for handlebars
      template =
        if HandlebarsAssets::Config.precompile
          compiled_hbs = Handlebars.precompile(source, HandlebarsAssets::Config.options)
          "Handlebars.template(#{compiled_hbs})"
        else
          "Handlebars.compile(#{JSON.dump(source)})"
        end

      # JS Wrappers
      template_namespace = HandlebarsAssets::Config.template_namespace

      if HandlebarsAssets::Config.amd?
        handlebars_amd_path = HandlebarsAssets::Config.handlebars_amd_path
        if HandlebarsAssets::Config.amd_with_template_namespace
          if @template_path.is_partial?
            "define(['#{handlebars_amd_path}'],function(Handlebars){ var t = #{template}; Handlebars.registerPartial(#{@template_path.name}, t); return t; })"
          else
            "define(['#{handlebars_amd_path}'],function(Handlebars){ return #{template}; });"
          end
        else
          if @template_path.is_partial?
            "define(['#{handlebars_amd_path}'],function(Handlebars){ var t = #{template}; Handlebars.registerPartial(#{@template_path.name}, t); return t; ;})"
          else
            "define(['#{handlebars_amd_path}'],function(Handlebars){ this.#{template_namespace} || (this.#{template_namespace} = {}); this.#{template_namespace}[#{@template_path.name}] = #{template}; return this.#{template_namespace}[#{@template_path.name}]; });"
          end
        end
      else
        if @template_path.is_partial?
          "(function() { Handlebars.registerPartial(#{@template_path.name}, #{template}); }).call(this);"
        else
          "(function() { this.#{template_namespace} || (this.#{template_namespace} = {}); this.#{template_namespace}[#{@template_path.name}] = #{template}; return this.#{template_namespace}[#{@template_path.name}]; }).call(this);"
        end
      end
    end

    class TemplatePath
      def initialize(path)
        @full_path = path
      end

      def check_extension(ext)
        result = false
        if ext.start_with? '.'
          ext = "\\#{ext}"
          result ||= !(@full_path =~ /#{ext}(\..*)*$/).nil?
        else
          result ||= !(@full_path =~ /\.#{ext}(\..*)*$/).nil?
        end
        result
      end

      def is_haml?
        result = false
        ::HandlebarsAssets::Config.hamlbars_extensions.each do |ext|
          result ||= check_extension(ext)
        end
        result
      end

      def is_slim?
        result = false
        ::HandlebarsAssets::Config.slimbars_extensions.each do |ext|
          result ||= check_extension(ext)
        end
        result
      end

      def is_ember?
        result = false
        ::HandlebarsAssets::Config.ember_extensions.each do |ext|
          result ||= check_extension(ext)
        end
        result
      end

      def is_partial?
        @full_path.gsub(%r{.*/}, '').start_with?('_')
      end

      def name
        template_name
      end

      private

      def relative_path
        path = @full_path.match(/.*#{HandlebarsAssets::Config.path_prefix}\/((.*\/)*([^.]*)).*$/)[1]
        if is_partial? && ::HandlebarsAssets::Config.chomp_underscore_for_partials?
          #handle case if partial is in root level of template folder
          path.gsub!(%r~^_~, '')
          #handle case if partial is in a subfolder within the template folder
          path.gsub!(%r~/_~, '/')
        end
        path
      end

      def template_name
        relative_path.dump
      end
    end
  end

  class NoOpEngine
    def initialize(data)
      @data = data
    end

    def render(*args)
      @data
    end
  end
end
