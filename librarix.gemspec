# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'librarix/version'

Gem::Specification.new do |spec|
  spec.name          = "librarix"
  spec.version       = Librarix::VERSION
  spec.authors       = ["Guillaume Dott"]
  spec.email         = ["guillaume+github@dott.fr"]
  spec.summary       = %q{A simple webapp to manage your collections}
  spec.description   = %q{Manage all your collections in your browser and automatically fetch infos from TheMovieDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra", '~> 1.4'
  spec.add_dependency "sinatra-contrib", '~> 1.4'
  spec.add_dependency "slim", '~> 3.0'
  spec.add_dependency "redis", '~> 3.2'
  spec.add_dependency "themoviedb", '~> 0.1'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sass", "~> 3.4"
end
