# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "handlebars_assets/version"

Gem::Specification.new do |s|
  s.name        = "handlebars_assets"
  s.version     = HandlebarsAssets::VERSION
  s.authors     = ["Les Hill"]
  s.email       = ["leshill@gmail.com"]
  s.homepage    = ""
  s.summary     = "Compile Handlebars templates in the Rails asset pipeline."
  s.description = "Compile Handlebars templates in the Rails asset pipeline."

  s.rubyforge_project = "handlebars_assets"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "execjs", ">= 1.2.9"
  s.add_runtime_dependency "tilt"
  s.add_runtime_dependency "sprockets", ">= 2.0.3"

  s.add_development_dependency "debugger"
  s.add_development_dependency "haml"
  s.add_development_dependency "rake"
  s.add_development_dependency "slim"
end
