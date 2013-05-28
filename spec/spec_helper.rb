require 'rubygems'
require 'bundler'
require 'rails'

Bundler.require :default, :development

require 'capybara/rspec'

Combustion.initialize! :active_record, :action_controller, :sprockets

require 'rspec/rails'
require 'capybara/rails'

require "invitational"

RSpec.configure do |config|
    config.use_transactional_fixtures = true
end

