require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'mister_bin'

include MenuCommander
require_relative 'spec_mixin'

RSpec.configure do |config|
  config.include SpecMixin
  config.include Colsole
  config.strip_ansi_escape = true
end

ENV['MENU_COMMANDER_ENV'] = 'test'

# Consistent Colsole output (for rspec_fixtures)
ENV['TTY'] = 'on'
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'
