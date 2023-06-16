lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'menu_commander/version'

Gem::Specification.new do |s|
  s.name        = 'menu_commander'
  s.version     = MenuCommander::VERSION
  s.summary     = 'Create menus for any CLI tool'
  s.description = 'Easily create menus for any command line tool using simple YAML configuration'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['menu']
  s.homepage    = 'https://github.com/DannyBen/menu_commander'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'colsole', '>= 0.8.1', '< 2'
  s.add_runtime_dependency 'extended_yaml', '~> 0.2'
  s.add_runtime_dependency 'mister_bin', '~> 0.7'
  s.add_runtime_dependency 'tty-prompt', '~> 0.23'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/menu_commander/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/menu_commander/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/DannyBen/menu_commander',
    'rubygems_mfa_required' => 'true',
  }
end
