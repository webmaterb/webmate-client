# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require 'webmate-client/version'

Gem::Specification.new do |gem|
  gem.name          = "webmate-client"
  gem.version       = Webmate::VERSION

  gem.authors       = ["Iskander Haziev"]
  gem.email         = ["gvalmon@gmail.com"]
  gem.description   = %q{Client Side bindings for Webmate Framework}
  gem.summary       = %q{Client Side bindings for Webmate Framework}
  gem.homepage      = "https://github.com/webmate/webmate-client"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency("coffee-script")
end
