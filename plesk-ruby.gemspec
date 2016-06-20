$:.push File.expand_path("../lib", __FILE__)

require "plesk/version"

Gem::Specification.new do |s|
  s.name        = "plesk-ruby"
  s.version     = Plesk::VERSION
  s.authors     = ["Adam Cooke"]
  s.email       = ["me@adamcooke.io"]
  s.homepage    = "https://adam.ac"
  s.summary     = "A client library for talking to the Plesk API."
  s.description = "A client library which facilitates communication to and from the Plesk API."
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.add_dependency "nokogiri", ">= 1.6.7", "< 1.8"
  s.licenses    = ["MIT"]
end
