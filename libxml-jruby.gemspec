require 'rake'

Gem::Specification.new do |s|
  s.name = "libxml-jruby"
  s.version = "1.0.0"
  s.date = "2008-09-20"
  s.summary = "LibXMLRuby compatibility layer for jruby"
  s.homepage = "http://rubyforge.org/projects/libxml-jruby"
  s.authors = "Michael Guterl"
  s.email = "mguterl @nospam@ gmail.com"
  s.rubyforge_project = "libxml-jruby"
  s.has_rdoc = false
  s.platform = "jruby"
  s.files = FileList['lib/**/*.rb', 'script/**/*', 'tasks/**/*', '[A-Z]*', 'test/**/*'].to_a
end
