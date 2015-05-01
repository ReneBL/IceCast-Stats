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
        "error" => "No existen datos. Por favor, compruebe que la URL del servidor IceCast es correcta."
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