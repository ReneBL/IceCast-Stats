###################################################################################
#IceCast-Stats is system for statistics generation and analysis
#for an IceCast streaming server
#Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
###################################################################################

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
