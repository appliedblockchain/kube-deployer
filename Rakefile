desc "Run" # use this to run the deployer on docker (default - binds to all ips)
task :run do
  sh "cd src && bundle exec rackup -o 0.0.0.0 -p 3000"
end

desc "Run (dev)"
task :run_dev do
  sh "cd src && rerun -p \"**/*.{rb}\" -- bundle exec rackup -o 0.0.0.0 -p 3000"
end

desc "Run Deploy"
task :deploy do
  sh "bundle exec ruby src/main.rb"
end

# desc "update config"
# task :run do
#   sh "cd #{PATH}/vendor && ruby update.rb"
# end

desc "Spec (tests)"
task :spec do
  sh "bundle exec rspec"
end

task test: :spec

task default: :run
