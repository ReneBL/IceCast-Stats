=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

require 'rails_helper'
require 'json'

RSpec.describe PollingController, type: :controller do
  before(:each) do
    admin = FactoryGirl.create(:admin)
    log_in(admin)
  end

  describe "when poll with invalid URL" do
    it "should return error in JSON" do
      expected_array = {
        "error" => "La dirección no es válida o no pertenece a un servidor de streaming IceCast."
      }
      expected = expected_array.to_json

      request "streaming.cuacfm.org", expected, response
    end
  end

  describe "when poll with valid URL, but response has bad format" do

    it "should return error in JSON" do
      expected_array = {
        "error" => "Datos incorrectos. Por favor, compruebe que la URL del servidor IceCast es correcta."
      }
      expected = expected_array.to_json

      # Hacemos una petición a un servicio REST JSON dummy 
      request "http://jsonplaceholder.typicode.com/posts", expected, response

      # Lo mismo pero sin especificar bien la ruta
      request "http://jsonplaceholder.typicode.com/", expected, response
    end

  end

  def request url, expected, response
    xhr :get, :poll, :route => url, :format => :json
    expect(response.body).to eql(expected)
  end

end