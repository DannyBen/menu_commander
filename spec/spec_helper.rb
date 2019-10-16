require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

require 'mister_bin'

include MenuCommander
require_relative 'spec_mixin'

RSpec.configure do |c|
  c.include SpecMixin
  c.include Colsole
end

ENV['TTY'] = 'on'