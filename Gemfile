gem 'rspec-rails', '>= 6.0' # Use version 6 for Rails 6 and 7 for Rails 7
gem 'rails-controller-testing'
# json 3.0 breaks ActiveSupport::JSON.decode on Rails 7.2 and 8.1.3.1 (https://github.com/rails/rails/pull/58601)
# TODO: remove this line when Redmine have backported this in main 6 & 7 branches
gem 'json', '< 3.0' unless dependencies.any? { |d| d.name == 'json' }
# nokogiri 1.19.5 changes CSS selector unescaping and HTML5 attribute serialization, which breaks Redmine core tests
# TODO: remove this block when Redmine core tests pass with it
if ENV['CI']
  dependencies.reject! { |d| d.name == 'nokogiri' }
  gem 'nokogiri', '~> 1.19.1', '< 1.19.5'
end
#for test coverage
# gem 'simplecov', '~> 0.9.1', :require => false, :group => :test
