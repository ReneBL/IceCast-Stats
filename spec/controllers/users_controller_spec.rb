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

RSpec.describe UsersController, type: :controller do

  describe "when get root page" do
    render_views
    
    before(:each) do
      FactoryGirl.create(:admin)
    end
    
    it "should return 200 OK" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    
    it "should return home/index template" do
      get :index
      expect(response).to render_template("index")
      expect(response.body).to match(/Login/)
    end
    
  end
  
  describe "when post admin credentials" do
    render_views
    
    before(:each) do
      FactoryGirl.create(:admin)
    end
    
    it "should route to create method" do
      expect(:post => "/login").to route_to(:controller => "users", :action => "create")
    end
    
    it "should redirect to home page with correct credentials" do
      post :create, session: { login: "admin", password: "admin" }
      expect(response).to redirect_to(home_path)
      expect(session[:user_id].nil?).to eql false
    end
    
    it "should advertise not valid login name" do
      post :create, session: { login: "adminnnnn", password: "admin" }
      expect(flash).not_to be_empty
      expect(flash[:wrong_login]).to eq("El usuario introducido no ha sido dado de alta en el sistema")
      expect(response).to redirect_to(login_form_path)
    end
    
    it "should advertise not valid password" do
      post :create, session: { login: "admin", password: "adminfalse" }
      expect(flash).not_to be_empty
      expect(flash[:wrong_password]).to eq("La contraseña no es válida")
      expect(response).to redirect_to(login_form_path)
    end
    
    it "should ignore non permitted params" do
      # Inyectamos un parámetro que no está contemplado
      post :create, session: { login: "admin", injectedParam: true }
      expect(response).to redirect_to(login_form_path)
    end
  end

  describe "when admin logout" do
    render_views
    
    before(:each) do
      FactoryGirl.create(:admin)
    end
    
    it "should be logged out" do
      post :create, session: { login: "admin", password: "admin" }
      expect(response).to redirect_to(home_path)
      expect(session[:user_id].nil?).to eql false
      delete :destroy
      expect(response).to redirect_to(root_path)
      expect(session[:user_id].nil?).to eql true
    end
  end

end
