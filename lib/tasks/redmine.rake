require "rspec/core/rake_task"

# Clear core's redmine:plugins:test task, else it's used
# and our own version is never triggered
Rake::Task["redmine:plugins:test"].clear

namespace :redmine do
  namespace :plugins do
    desc "Runs the plugins tests."
    task :test do
      Rake::Task["redmine:plugins:spec"].invoke
      Rake::Task["redmine:plugins:test:units"].invoke
      Rake::Task["redmine:plugins:test:functionals"].invoke
      Rake::Task["redmine:plugins:test:integration"].invoke
    end

    desc "Runs the plugins specs."
    RSpec::Core::RakeTask.new :spec => "db:test:prepare" do |t|
      plugin_dir = "plugins/#{ENV["NAME"] || "*"}"
      spec_dirs = Dir.glob("#{plugin_dir}/spec").join(":")
      t.pattern = "#{plugin_dir}/spec/**/*_spec.rb"
      t.ruby_opts = "-I#{spec_dirs}"
    end
  end
end
