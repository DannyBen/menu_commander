lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'menu_commander/version'

Gem::Specification.new do |s|
  s.name        = 'menu_commander'
  s.version     = MenuCommander::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Create menus for any CLI tool"
  s.description = "Easily create menus for any command line tool using simple YAML configuration"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['menu']
  s.homepage    = 'https://github.com/dannyben/menu_commander'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.3.0"

  s.add_runtime_dependency 'mister_bin', '~> 0.3'
  s.add_runtime_dependency 'colsole', '~> 0.5'
  s.add_runtime_dependency 'tty-prompt', '~> 0.18'
end
