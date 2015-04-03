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
      expect(flash[:wrong_login]).to eq("Login no válido")
      expect(response).to redirect_to(login_form_path)
    end
    
    it "should advertise not valid password" do
      post :create, session: { login: "admin", password: "adminfalse" }
      expect(flash).not_to be_empty
      expect(flash[:wrong_password]).to eq("Password no válida")
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
