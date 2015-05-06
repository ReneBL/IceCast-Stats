require 'rails_helper'
require 'spec_helper'

feature "connections between dates" do

  def log_in_process 
    visit "/"
    within '#buttonLogin' do
      click_button 'Login'
    end
    within '#modalLogin' do
      fill_in 'Login', :with => 'admin'
      fill_in 'Password', :with => 'admin'
      click_button 'Login'
    end
  end

  def initial_state
    click_button "menuButton"
    click_link "Estadísticas"
    find(:css, '#Localizacion').click
  end

  background do
    2.times do
      FactoryGirl.create(:connection_from_Spain)
    end
    FactoryGirl.create(:connection_from_France)

    3.times do
      FactoryGirl.create(:connection_from_United_States)
    end
      
    admin = FactoryGirl.create(:admin)
    log_in_process
    initial_state
  end

  scenario "show country chart with connections", :js => true do
  	
  end
end
