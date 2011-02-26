require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Rake::TestTask.new("test:units") do |t|
  t.libs << 'lib'
  t.libs << '.'
  t.pattern = 'test/unit/**/test_*.rb'
end

Rake::TestTask.new("test:integration") do |t|
  t.libs << 'lib'
  t.libs << '.'
  t.pattern = 'test/integration/**/test_*.rb'
end

task :test => ['test:units', 'test:integration']

task :default => 'test:units'

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/test_*.rb']
    t.verbose = true
  end
rescue LoadError
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'dropsite'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Build gem package"
task :package => 'dropsite.gemspec' do
  sh "gem build dropsite.gemspec"
end
