# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudsearch/version"

Gem::Specification.new do |s|
  s.name        = "cloudsearch"
  s.version     = Cloudsearch::VERSION
  s.authors     = ["Jiren Patel", "Shailesh Patil"]
  s.email       = ["jiren@joshsoftware.com", "shailesh@joshsoftware.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "cloudsearch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "nokogiri"
  s.add_dependency "faraday"
  s.add_dependency "faraday_middleware"
  s.add_dependency "faraday_middleware-parse_oj"
  # s.add_runtime_dependency "rest-client"
end
