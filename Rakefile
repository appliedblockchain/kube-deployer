desc "Run"
task :run do
  sh "cd src && bundle exec rake"
end

desc "Run Deploy"
task :deploy do
  sh "bundle exec ruby src/main.rb"
end

# desc "update config"
# task :run do
#   sh "cd vendor && ruby update.rb"
# end

desc "Spec (tests)"
task :spec do
  sh "bundle exec rspec"
end

task test: :spec

task default: :run
