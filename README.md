Redmine base_rspec plugin
======================

Allows using RSpec as a testing tool instead of plain Test::Unit.
Ensures the rubocop and plugins are part of the bundle.

Note that this plugin mainly targets developers of Redmine plugins. If you
are not a Redmine plugin developer, chances are you are not at the right
place!

Usage
-----

Having the plugin installed in your `plugins/` directory is sufficient.

As of today the plugin provides the following things:

- adds a `Gemfile` so that bundler will pick up rspec and rspec-rails
- modifies Redmine's `redmine:plugins:test` task so that all plugins specs
  run along with test/unit ones (you can restrict to a specific plugin with
  the "NAME" environment variable, like other redmine plugin test tasks)
- adds this plugin's `spec/` directory to `$LOAD_PATH` and provides a default
  `spec_helper` file for your specs ; hence you can just `require "spec_helper"`
  on top of your spec files if this default one is sufficient for you
- enables code coverage with SimpleCov if your environment contains the
  environment variable `COVERAGE`

Note that if you want to run specs directly with the `rspec` command, and
you use the `spec_helper` of this plugin directly, you may have to specify
the `-I` option to have the correct load path:

```bash
    rspec -Iplugins/redmine_base_rspec/spec  plugins/<your_plugin>/spec
```

Installation
------------

This plugin is compatible with Redmine 2.1.0+.

Please apply general instructions for plugins [here](http://www.redmine.org/wiki/redmine/Plugins).

First download the source or clone the plugin and put it in the "plugins/"
directory of your redmine instance. Note that this is crucial that the
directory is named redmine_base_rspec !

Then execute:

```bash
    $ bundle install
```

And finally restart your Redmine instance.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
