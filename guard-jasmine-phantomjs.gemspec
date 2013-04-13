# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/jasmine_phantomjs/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-jasmine-phantomjs"
  spec.version       = Guard::JasminePhantomjsVersion::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["yagince"]
  spec.email         = ["straitwalk@gmail.com"]
  spec.homepage      = "https://github.com/yagince"
  spec.license       = "MIT"
  spec.description   = "guard plugin for jasmine test"
  spec.summary       = "guard plugin for jasmine test"

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "rake"
  spec.add_dependency "guard", ">= 1.7.0"
  spec.add_dependency "childprocess"
  spec.add_dependency "typescript"
  spec.add_dependency "phantomjs.rb"

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
