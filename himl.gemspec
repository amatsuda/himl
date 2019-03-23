
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "himl/version"

Gem::Specification.new do |spec|
  spec.name          = "himl"
  spec.version       = Himl::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'HTML-based Indented Markup Language'
  spec.description   = 'HTML + ERB + Haml = Himl'
  spec.homepage      = 'https://github.com/amatsuda/himl'
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'tilt'
end
