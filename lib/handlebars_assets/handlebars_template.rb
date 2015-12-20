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

  # Sprockets <= 3
  class HandlebarsTemplate < Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def initialize_engine
      HandlebarsRenderer.initialize_engine
    end

    def prepare
      @engine = renderer.choose_engine(data)
    end

    def evaluate(scope, locals, &block)
      source = @engine.render(scope, locals, &block)
      renderer.compile(source)
    end

    private

    def renderer
      @renderer ||= HandlebarsRenderer.new(path: @file)
    end
  end

  # Sprockets 4
  class HandlebarsProcessor

    def self.instance
      @instance ||= new
    end

    def self.call(input)
      instance.call(input)
    end

    def self.cache_key
      instance.cache_key
    end

    attr_reader :cache_key

    def initialize(options = {})
      @cache_key = [self.class.name, ::HandlebarsAssets::VERSION, options].freeze
    end

    def call(input)
      renderer = HandlebarsRenderer.new(path: input[:filename])
      engine = renderer.choose_engine(input[:data])
      renderer.compile(engine.render)
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

  class HandlebarsRenderer
    include Unindent

    def self.initialize_engine
      return if @initialized

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

      @initialized = true
    end

    def initialize(options)
      self.class.initialize_engine
      @template_path = TemplatePath.new(options[:path])
    end

    def choose_engine(data)
      if @template_path.is_haml?
        Haml::Engine.new(data, HandlebarsAssets::Config.haml_options)
      elsif @template_path.is_slim?
        Slim::Template.new(HandlebarsAssets::Config.slim_options) { data }
      else
        NoOpEngine.new(data)
      end
    end

    def compile(source)
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
end
