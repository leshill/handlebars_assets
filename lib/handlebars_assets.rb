require "handlebars_assets/version"
require 'handlebars_assets/engine'

module HandlebarsAssets
  autoload(:Handlebars, 'handlebars_assets/handlebars')
  autoload(:Loader, 'handlebars_assets/loader')
  autoload(:TiltHandlebars, 'handlebars_assets/tilt_handlebars')
end
