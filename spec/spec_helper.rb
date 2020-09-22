ENV['RAILS_ENV'] ||= 'test'

# load simplecov
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    coverage_dir 'tmp/coverage'
    ###    require "pry"
    ###    binding.pry
    # exclude core dirs coverage
    add_filter do |file|
      file.filename.include?('/lib/plugins/') ||
        file.filename.exclude?('/plugins/')
    end
  end
end

# load rails/redmine
require_relative '../../../config/environment'

# test gems
require 'rspec/rails'
# require 'rspec/autorun'
require 'rspec/mocks'
require 'rspec/mocks/standalone'

module AssertSelectRoot
  def document_root_element
    html_document.root
  end
end

# rspec base config
RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include AssertSelectRoot, type: :request
end

def with_settings(options, &_block)
  saved_settings = options.keys.each_with_object({}) do |k, h|
    h[k] = case Setting[k]
           when Symbol, false, true, nil
             Setting[k]
           else
             Setting[k].dup
           end
  end
  options.each { |k, v| Setting[k] = v }
  yield
ensure
  saved_settings&.each { |k, v| Setting[k] = v }
end
