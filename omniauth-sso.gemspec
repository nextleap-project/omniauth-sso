Gem::Specification.new do |s|
  s.name        = 'omniauth-sso'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Omniauth strategy for ai's sso"
  s.description = <<-EODESC
Omniauth strategy for "ai's sso"(https://git.autistici.org/ai/sso) based on rbsso.
  EODESC
  s.authors     = ['Azul']
  s.email       = 'azul@riseup.net'
  s.homepage    = 'https://0xacab.org/riseup/omniauth-sso'

  s.add_runtime_dependency 'omniauth', '~> 1.3'
  s.add_runtime_dependency 'rbsso', '~> 0.1'

  s.add_development_dependency 'rake', '>= 10', '< 13'
  s.add_development_dependency 'minitest', '~>5.0'
  s.add_development_dependency 'minitest-autotest', '~> 1.0'
  s.add_development_dependency 'autotest-suffix', '~> 1.1'
  s.add_development_dependency 'simplecov', '~> 0.11'
  s.add_development_dependency 'rack-test', '~> 0.6', '>= 0.6.3'
  s.add_development_dependency 'conventional-changelog', '~> 1.2'

  s.files         = ['README.md', 'CHANGELOG.md'] + Dir['lib/**/*.rb']
  s.test_files    = Dir['test/**/*.rb']
  s.require_paths = ["lib"]
end
