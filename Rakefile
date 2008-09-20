# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'libxml-jruby'

task :default => 'spec:run'

PROJ.name = 'libxml-jruby'
PROJ.authors = 'FIXME (who is writing this software)'
PROJ.email = 'FIXME (your e-mail)'
PROJ.url = 'FIXME (project homepage)'
PROJ.rubyforge.name = 'libxml-jruby'

PROJ.spec.opts << '--color'

# EOF
