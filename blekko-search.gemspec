# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blekko-search/version'

Gem::Specification.new do |gem|
  gem.name          = "blekko-search"
  gem.version       = Blekko::Search::VERSION
  gem.authors       = ["Sean Devine"]
  gem.email         = ["barelyknown@icloud.com"]
  gem.description   = %q(Search and manage slashtags for blekko.com)
  gem.summary       = %q(Search and manage slashtags for blekko.com)
  gem.homepage      = "https://github.com/barelyknown/blekko-search"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
