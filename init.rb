Redmine::Plugin.register :redmine_base_rspec do
  name 'Redmine Base Rspec plugin'
  author 'Jean-Baptiste BARTH'
  description 'This is a plugin for Redmine'
  version '6.0.1'
  url 'https://github.com/jbbarth/redmine_base_rspec'
  author_url 'jeanbaptiste.barth@gmail.com'
end

# Specific patch for Redmine 6.0.1
# Patch core helper method to temporary prevent a bug with GitHub Action Workflows on Redmine 6.0
module BaseRspec
  module IconsHelperPatch
    def principal_icon(principal, **options)

      if principal.is_a?(String)
        puts "Error in principal_icon: First argument has to be a Principal, was the String #{principal.inspect}"
        return nil
      end

      raise ArgumentError, "First argument has to be a Principal, was #{principal.inspect}" unless principal.is_a?(Principal)

      principal_class = principal.class.name.downcase
      sprite_icon('group', **options) if ['groupanonymous', 'groupnonmember', 'group'].include?(principal_class)
    end
  end
end

module Hooks
  class ModelHook < Redmine::Hook::Listener
    def after_plugins_loaded(_context = {})
      if Redmine::VERSION::MAJOR >= 6
        IconsHelper.prepend BaseRspec::IconsHelperPatch
        ActionView::Base.prepend IconsHelper
      end
    end
  end
end
