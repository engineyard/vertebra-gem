require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

GEM = "vertebra-gemtool"
GEM_VERSION = "0.0.2"
AUTHOR = "EY Dev Team"
EMAIL = "dev@engineyard.com"
HOMEPAGE = "http://code.engineyard.com"
SUMMARY = "A Vertebra actor and runner for manipulating gems on Linux"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  s.executables = %w(vgem)
  
  s.add_dependency "vertebra"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

task :deploy do
  puts "Copying gem to gem server..."
  puts `eyscp pkg/#{GEM}-#{GEM_VERSION}.gem ey01-s00271:/data/gems/gems`
  puts `eyssh ey01-s00271 'cd /data/gems; gem generate_index'`  
end
