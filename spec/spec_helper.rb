ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"
require "rspec/rails"
require "pry"

Dir[Rails.root.join("spec/support/*.rb")].each &method(:require)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.include FactoryGirl::Syntax::Methods

  config.include Helpers::Generic
  config.include Helpers::Controller,  type: :controller
  config.include Helpers::Integration, type: :feature
end
