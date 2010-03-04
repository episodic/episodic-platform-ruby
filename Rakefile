require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/episodic/platform'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'episodic-platform' do
  self.developer 'Randy Simon', 'support@episodic.com'
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.rubyforge_name       = self.name # TODO this is default value
  self.version              = '0.9'

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

gem 'rdoc'
gem 'hanna'
require 'rake/rdoctask'
require 'hanna/rdoctask'

desc 'Generate RDoc documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
#  rdoc.rdoc_files.include('README.rdoc', 'LICENSE', 'CHANGELOG').
#    include('lib/**/*.rb').
##    exclude('lib/will_paginate/named_scope*').

  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "Episodic Platform GEM documentation"

  rdoc.rdoc_dir = 'doc' # rdoc output folder
#  rdoc.options << '--webcvs=http://github.com/mislav/will_paginate/tree/master/'
end


# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
