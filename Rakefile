['rubygems',"rake/gempackagetask",'rake/rdoctask',"rake/clean",'spec', 'spec/rake/spectask', File.expand_path('./lib/email_spec.rb')].each {|file| require file}

# package + maintenance stuff
spec = Gem::Specification.new do |s|
  s.name         = "email_spec"
  s.version      = EmailSpec::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Ben Mabrey', 'Aaron Gibralter', 'Mischa Fierer']
  s.email        = "ben@benmabey.com"
  s.homepage     = "http://github.com/bmabey/email-spec/"
  s.summary      = "Easily test email in rspec and cucumber"
  s.bindir       = "bin"
  s.description  = s.summary
  s.require_path = "lib"
  s.files        = %w(History.txt install.rb MIT-LICENSE.txt README.rdoc Rakefile) + Dir["lib/**/*"] + Dir["generators/**/*"] + Dir["spec/**/*"] + Dir["examples/**/*"]
  # rdoc
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc MIT-LICENSE.txt)
end

desc 'Show information about the gem.'
task :debug_gem do
  puts spec.to_ruby
end

task :gemspec do
  system "rake debug_gem | grep -v \"(in \" > email-spec.gemspec"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end


CLEAN.include ["pkg", "*.gem", "doc", "ri", "coverage", '**/.*.sw?', '*.gem', '.config', '**/.DS_Store', '**/*.class', '**/*.jar', '**/.*.swp' ]

desc 'Install the package as a gem.'
task :install_gem => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --local #{gem}"
end

# Testing

desc "Run the generator on the tests"
task :generate do
  system "mkdir -p examples/rails_root/vendor/plugins/email_spec"
  system "cp -R generators examples/rails_root/vendor/plugins/email_spec"
  system "cd examples/rails_root; ./script/generate email_spec"
end

task :features => [:generate] do
  system("cucumber examples/rails_root/features")
end

task :default => :features

