require 'rubygems'
require 'bundler/setup'

require 'combustion'
require 'capybara/rspec'

require 'invitational'

Combustion.initialize! :active_record, :action_controller, :action_view, :sprockets

require 'rspec/rails'
require 'capybara/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end

