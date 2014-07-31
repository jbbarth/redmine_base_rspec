Redmine::Plugin.register :redmine_base_rspec do
  name 'Redmine Base Rspec plugin'
  author 'Jean-Baptiste BARTH'
  description 'This is a plugin for Redmine'
  version '0.0.2'
  url 'https://github.com/jbbarth/redmine_base_rspec'
  author_url 'jeanbaptiste.barth@gmail.com'
end

#add our spec/ directory to the path so other plugins can simply
#put this on top of their spec:
#
#   require "spec_helper"
#
$LOAD_PATH << File.expand_path("../../spec")
