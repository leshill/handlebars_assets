# Based on https://github.com/cowboyd/handlebars.rb
require 'pathname'
require 'execjs'

module HandlebarsAssets
  class Loader
    def initialize
      @path = Pathname(__FILE__).dirname.join('..','..','vendor','assets','javascripts')
    end

    def load_context
      modname = 'handlebars'
      filename = modname =~ /\.js$/ ? modname : "#{modname}.js"
      filepath = @path.join(filename)
      fail LoadError, "no such file: #{filename}" unless filepath.exist?
      ExecJS.compile(filepath.read)
    end
  end
end
