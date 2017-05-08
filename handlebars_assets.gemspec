# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "handlebars_assets/version"

Gem::Specification.new do |s|
  s.name        = "handlebars_assets"
  s.version     = HandlebarsAssets::VERSION
  s.authors     = ["Les Hill"]
  s.licenses    = ["MIT"]
  s.email       = ["leshill@gmail.com"]
  s.homepage    = "https://github.com/leshill/handlebars_assets"
  s.summary     = "Compile Handlebars templates in the Rails asset pipeline."
  s.description = "A Railties Gem to compile hbs assets"

  s.rubyforge_project = "handlebars_assets"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "execjs", "~> 2.0"
  s.add_runtime_dependency "tilt", ">= 1.2"
  s.add_runtime_dependency "sprockets", ">= 2.0.0"

  s.add_development_dependency "minitest", '~> 5.5'
  s.add_development_dependency "haml", '~> 4.0'
  s.add_development_dependency "rake", '~> 10.0'
  s.add_development_dependency "slim", '~> 3.0'
  s.add_development_dependency "appraisal"

  s.post_install_message = "Remember to rake assets:clean or rake assets:purge on update! this is required because of handlebars updates"
end
