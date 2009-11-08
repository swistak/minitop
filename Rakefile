desc "Runs test files"
task :test do
  $:<< 'lib' << 'test'
  Dir.glob('test/*_test.rb').each{|test| load(test)}
end

task :default => :test
