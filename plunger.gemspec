# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "plunger/version"

Gem::Specification.new do |s|
  s.name        = "plunger"
  s.version     = Plunger::VERSION
  s.authors     = ["Andriy Yanko"]
  s.email       = ["andriy.yanko@gmail.com"]
  s.homepage    = "https://github.com/railsware/plunger"
  s.summary     = %q{Code Review Tool}
  s.description = %q{Ruby Wrapper for Rietveld Code Review, hosted on Google App Engine}

  s.rubyforge_project = "plunger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
