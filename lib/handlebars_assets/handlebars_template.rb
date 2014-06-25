require 'tilt'
require 'json'

module HandlebarsAssets
  module Unindent
    # http://bit.ly/aze9FV
    # Strip leading whitespace from each line that is the same as the
    # amount of whitespace on the first line of the string.
    # Leaves _additional_ indentation on later lines intact.
    def unindent(heredoc)
      heredoc.gsub(/^#{heredoc[/\A\s*/]}/, '')
    end
  end

  class HandlebarsTemplate < Tilt::Template

    include Unindent

    def self.default_mime_type
      'application/javascript'
    end

    def initialize_engine
      begin
        require 'haml'
      rescue LoadError
        # haml not available
      end
      begin
        require 'slim'
      rescue LoadError
        # slim not available
      end
    end

    def prepare
      @template_path = TemplatePath.new(@file)
      @engine =
        if @template_path.is_haml?
          Haml::Engine.new(data, HandlebarsAssets::Config.haml_options)
        elsif @template_path.is_slim?
          Slim::Template.new(HandlebarsAssets::Config.slim_options) { data }
        else
          nil
        end
    end

    def evaluate(scope, locals, &block)
      source =
        if @engine
          @engine.render(scope, locals, &block)
        else
          data
        end

      # remove trailing \n on file, for some reason the directives pipeline adds this
      source.chomp!($/)

      # handle the case of multiple frameworks combined with ember
      # DEFER: use extension setup for ember
      if (HandlebarsAssets::Config.multiple_frameworks? && @template_path.is_ember?) ||
         (HandlebarsAssets::Config.ember? && !HandlebarsAssets::Config.multiple_frameworks?)
        compile_ember(source)
      else
        compile_default(source)
      end
    end

    def compile_ember(source)
      "window.Ember.TEMPLATES[#{@template_path.name}] = Ember.Handlebars.compile(#{JSON.dump(source)});"
    end

    def compile_default(source)
      template =
        if HandlebarsAssets::Config.precompile
          compiled_hbs = Handlebars.precompile(source, HandlebarsAssets::Config.options)
          "Handlebars.template(#{compiled_hbs})"
        else
          "Handlebars.compile(#{JSON.dump(source)})"
        end

      template_namespace = HandlebarsAssets::Config.template_namespace

      if HandlebarsAssets::Config.amd?
        handlebars_amd_path = HandlebarsAssets::Config.handlebars_amd_path
        if HandlebarsAssets::Config.amd_with_template_namespace
          if @template_path.is_partial?
            unindent <<-PARTIAL
              define(['#{handlebars_amd_path}'],function(Handlebars){
                var t = #{template};
                Handlebars.registerPartial(#{@template_path.name}, t);
                return t;
              ;})
            PARTIAL
          else
            unindent <<-TEMPLATE
              define(['#{handlebars_amd_path}'],function(Handlebars){
                return #{template};
              });
            TEMPLATE
          end
        else
          if @template_path.is_partial?
            unindent <<-PARTIAL
              define(['#{handlebars_amd_path}'],function(Handlebars){
                var t = #{template};
                Handlebars.registerPartial(#{@template_path.name}, t);
                return t;
              ;})
            PARTIAL
          else
            unindent <<-TEMPLATE
              define(['#{handlebars_amd_path}'],function(Handlebars){
                this.#{template_namespace} || (this.#{template_namespace} = {});
                this.#{template_namespace}[#{@template_path.name}] = #{template};
                return this.#{template_namespace}[#{@template_path.name}];
              });
            TEMPLATE
          end
        end
      else
        if @template_path.is_partial?
          unindent <<-PARTIAL
            (function() {
              Handlebars.registerPartial(#{@template_path.name}, #{template});
            }).call(this);
          PARTIAL
        else
          unindent <<-TEMPLATE
            (function() {
              this.#{template_namespace} || (this.#{template_namespace} = {});
              this.#{template_namespace}[#{@template_path.name}] = #{template};
              return this.#{template_namespace}[#{@template_path.name}];
            }).call(this);
          TEMPLATE
        end
      end
    end

    protected

    class TemplatePath
      def initialize(path)
        @full_path = path
      end

      def is_haml?
        result = false
        ::HandlebarsAssets::Config.hamlbars_extensions.each do |ext|
          if ext.start_with? '.'
            ext = '\\#{ext}'
            result ||= !(@full_path =~ /#{ext}(\..*)*$/).nil?
          else
            result ||= !(@full_path =~ /\.#{ext}(\..*)*$/).nil?
          end
        end
        result
      end

      def is_slim?
        result = false
        ::HandlebarsAssets::Config.slimbars_extensions.each do |ext|
          if ext.start_with? '.'
            ext = '\\#{ext}'
            result ||= !(@full_path =~ /#{ext}(\..*)*$/).nil?
          else
            result ||= !(@full_path =~ /\.#{ext}(\..*)*$/).nil?
          end
        end
        result
      end

      def is_partial?
        @full_path.gsub(%r{.*/}, '').start_with?('_')
      end

      def is_ember?
        result = false
        ::HandlebarsAssets::Config.ember_extensions.each do |ext|
          if ext.start_with? '.'
            ext = '\\#{ext}'
            result ||= !(@full_path =~ /#{ext}(\..*)*$/).nil?
          else
            result ||= !(@full_path =~ /\.#{ext}(\..*)*$/).nil?
          end
        end
        result
      end

      def name
        template_name
      end

      private

      def relative_path
        @full_path.match(/.*#{HandlebarsAssets::Config.path_prefix}\/((.*\/)*([^.]*)).*$/)[1]
      end

      def template_name
        relative_path.dump
      end
    end
  end
end
