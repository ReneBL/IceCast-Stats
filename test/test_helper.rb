require 'simplecov'
SimpleCov.start 'rails'

require 'webmock/rspec'
WebMock.allow_net_connect!(:net_http_connect_on_start => true)

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Clase de utilidad necesaria para utilizar factorías de creación de objetos útiles para agilizar tests
  include FactoryGirl::Syntax::Methods
end
