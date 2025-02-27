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
        !file.filename.include?('/plugins/')
    end
  end
end

# load rails/redmine
require File.expand_path('../../../../config/environment', __FILE__)

require File.expand_path("#{::Rails.root}/test/object_helpers", __FILE__)
include ObjectHelpers

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
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.fixture_paths = config.fixture_path if Redmine::VERSION::MAJOR >= 6
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include AssertSelectRoot, :type => :request
  config.before(:each, type: :system) do
    driven_by(
      :selenium,
      using: :headless_chrome,
      screen_size: [1024, 900]
    )
  end
  if Redmine::VERSION::MAJOR >= 5
    Rails.application.load_tasks
    config.before(:suite) do
      # Run Zeitwerk check before the suite runs
      expect {
        Rake::Task['zeitwerk:check'].invoke
      }.to_not raise_error
    end
  end
end

def with_settings(options, &block)
  saved_settings = options.keys.inject({}) do |h, k|
    h[k] = case Setting[k]
           when Symbol, false, true, nil
             Setting[k]
           else
             Setting[k].dup
           end
    h
  end
  options.each { |k, v| Setting[k] = v }
  yield
ensure
  saved_settings.each { |k, v| Setting[k] = v } if saved_settings
end


def log_user(login, password)
  return if User.current.logged? && User.current.login == login
  log_out if User.current.logged?

  visit '/my/page'
  expect(page).to have_current_path(%r{^/login}, wait: true)

  if Redmine::Plugin.installed?(:redmine_scn)
    click_on("ou s'authentifier par login / mot de passe")
  end

  within('#login-form form') do
    fill_in 'username', with: login
    fill_in 'password', with: password
    find('input[name=login]').click
  end
  expect(page).to have_current_path('/my/page', wait: true)
end

def log_out
  post '/logout'
  assert_redirected_to '/'
  follow_redirect!
  assert_response :success
end

def assert_mail_body_match(expected, mail, message = nil)
  if expected.is_a?(String)
    expect(mail_body(mail)).to include(expected)
  else
    assert_match expected, mail_body(mail), message
  end
end

def assert_mail_body_no_match(expected, mail, message = nil)
  if expected.is_a?(String)
    expect(mail_body(mail)).to_not include expected
  else
    assert_no_match expected, mail_body(mail), message
  end
end

def mail_body(mail)
  mail.parts.first.body.encoded
end

def uploaded_test_file(name, mime)
  fixture_file_upload("#{::Rails.root}/test/fixtures/files/#{name}", mime, true)
end
