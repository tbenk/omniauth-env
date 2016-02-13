# coding: utf-8
require File.expand_path('../lib/omniauth-env/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "omniauth-env"
  spec.version       = OmniAuth::Env::VERSION
  spec.authors       = ["Shahaf Arad"]
  spec.email         = ["shahaf2a@gmail.com"]
  spec.description   = %q{REMOTE_USER strategy for omniauth.}
  spec.summary       = %q{REMOTE_USER strategy for omniauth.}
  spec.homepage      = "https://github.com/av3r4ge/omniauth-env"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth', '~> 1.0'
  spec.add_runtime_dependency 'gitlab_omniauth-ldap', '~> 1.2.1'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
