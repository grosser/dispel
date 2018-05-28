$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "dispel"
require "#{name.gsub("-","/")}/version"

Gem::Specification.new name, Dispel::VERSION do |s|
  s.summary = "Remove evil curses"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 2.1.0' # curses does not build on 1.9
  s.add_runtime_dependency "curses"
end
