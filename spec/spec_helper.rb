ENV['RAILS_ENV'] ||= 'test'

#load simplecov
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    coverage_dir 'tmp/coverage'
###    require "pry"
###    binding.pry
    #exclude core dirs coverage
    add_filter do |file|
      file.filename.include?('/lib/plugins/') || 
        !file.filename.include?('/plugins/')
    end
  end
end

#load rails/redmine
require File.expand_path('../../../../config/environment', __FILE__)

#test gems
require 'rspec/rails'
# require 'rspec/autorun'
require 'rspec/mocks'
require 'rspec/mocks/standalone'

#rspec base config
RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
