gem 'rspec-rails'
gem 'rails-controller-testing'
# json 3.0 breaks ActiveSupport::JSON.decode on Rails 7.2 and 8.1.3.1 (https://github.com/rails/rails/pull/58601)
# TODO: remove this line when Redmine have backported this in main 6 & 7 branches
gem 'json', '< 3.0' unless dependencies.any? { |d| d.name == 'json' }
# nokogiri 1.19.5 changes CSS selector unescaping and HTML5 attribute serialization, which breaks the tests of
# Redmine versions that still allow older nokogiri releases (up to 6.1.6 and 7.0.3)
# TODO: remove this block when CI no longer tests those versions
if ENV['CI'] && dependencies.find { |d| d.name == 'nokogiri' }&.requirement&.satisfied_by?(Gem::Version.new('1.19.4'))
  dependencies.reject! { |d| d.name == 'nokogiri' }
  gem 'nokogiri', '~> 1.19.1', '< 1.19.5'
end
#for test coverage
# gem 'simplecov', '~> 0.9.1', :require => false, :group => :test
