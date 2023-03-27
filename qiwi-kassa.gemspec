lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qiwi/kassa/version'

Gem::Specification.new do |spec|
  spec.name          = 'qiwi-kassa'
  spec.version       = Qiwi::Kassa::VERSION
  spec.authors       = 'Maxim Shirokov'
  spec.email         = 'maximshirokov21@gmail.com'

  spec.summary       = 'QiwiKassa binding for Ruby'
  spec.description   = 'Provides support for payment operations using QiwiKassa API services'
  spec.homepage      = 'https://github.com/OnlinetoursGit/qiwi-kassa'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
end
