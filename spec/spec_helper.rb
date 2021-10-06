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

require File.expand_path("#{::Rails.root}/test/object_helpers", __FILE__)
include ObjectHelpers

#test gems
require 'rspec/rails'
# require 'rspec/autorun'
require 'rspec/mocks'
require 'rspec/mocks/standalone'

module AssertSelectRoot
  def document_root_element
    html_document.root
  end
end

#rspec base config
RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include AssertSelectRoot, :type => :request
  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome, options: { args: ["headless", "no-sandbox", "disable-gpu"] }
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
  options.each {|k, v| Setting[k] = v}
  yield
ensure
  saved_settings.each {|k, v| Setting[k] = v} if saved_settings
end

def log_user(login, password)
  visit '/my/page'
  expect(current_path).to eq '/login'

  if Redmine::Plugin.installed?(:redmine_scn)
    click_on("ou s'authentifier par login / mot de passe")
  end

  within('#login-form form') do
    fill_in 'username', with: login
    fill_in 'password', with: password
    find('input[name=login]').click
  end
  expect(current_path).to eq '/my/page'
end

def assert_mail_body_match(expected, mail, message=nil)
  if expected.is_a?(String)
    expect(mail_body(mail)).to include(expected)
  else
    assert_match expected, mail_body(mail), message
  end
end

def assert_mail_body_no_match(expected, mail, message=nil)
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
  fixture_file_upload("files/#{name}", mime, true)
end
