$:.push File.expand_path('lib', __dir__)
require 'handlebars_assets/version'

Gem::Specification.new do |s|
  s.name        = 'handlebars_assets'
  s.version     = HandlebarsAssets::VERSION
  s.authors     = ['Les Hill']
  s.licenses    = ['MIT']
  s.email       = ['leshill@gmail.com']
  s.homepage    = 'https://github.com/leshill/handlebars_assets'
  s.summary     = 'Compile Handlebars templates in the Rails asset pipeline.'
  s.description = 'A Railties Gem to compile hbs assets'
  s.required_ruby_version = '~> 3.0'

  s.rubyforge_project = 'handlebars_assets'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'execjs', '~> 2.10'
  s.add_runtime_dependency 'sprockets', '>= 3.0'
  s.add_runtime_dependency 'tilt', '>= 2.4'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'haml', '>= 4.0', '< 7.0'
  s.add_development_dependency 'minitest', '~> 5.25'
  s.add_development_dependency 'rake', '~> 13.2'
  s.add_development_dependency 'slim', '~> 5.2.1'

  s.post_install_message = 'Remember to rake assets:clean or rake assets:purge on update! this is required because of handlebars updates'
end
