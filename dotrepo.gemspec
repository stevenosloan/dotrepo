require File.expand_path( "../lib/dotrepo/version", __FILE__ )

Gem::Specification.new do |gem|

  gem.name         = 'dotrepo'
  gem.version      = Dotrepo::VERSION
  gem.platform     = Gem::Platform::RUBY

  gem.summary      = 'A simple manager for your dotfiles'
  gem.description  = %q{ A simple manager for your dotfiles }
  gem.authors      = ["Steven Sloan"]
  gem.email        = ["stevenosloan@gmail.com"]
  gem.homepage     = "http://github.com/stevenosloan/dotrepo"
  gem.license      = 'MIT'

  gem.files        = Dir["{lib}/**/*.rb"]
  gem.test_files   = Dir["spec/**/*.rb"]
  gem.require_path = "lib"
  gem.executable   = "dotrepo"

  gem.add_dependency "thor", "~> 0"

end