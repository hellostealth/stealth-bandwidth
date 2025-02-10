$LOAD_PATH.push File.expand_path('../lib', __FILE__)

version = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

Gem::Specification.new do |s|
  s.name = 'stealth-bandwidth'
  s.summary = 'Stealth Bandwidth SMS driver'
  s.description = 'Bandwidth.com SMS driver for Stealth.'
  s.homepage = 'https://github.com/hellostealth/stealth-bandwidth'
  s.licenses = ['MIT']
  s.version = version
  s.authors = ['Emilie Morissette']
  s.email = ['emorissettegregoire@gmail.com']

  s.add_dependency 'stealth', '>= 3.0.0.alpha1'
  s.add_dependency 'http', '~> 4.1'
  s.add_dependency 'oj', '~> 3.11'

  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  s.add_development_dependency 'rack-test', '~> 1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
