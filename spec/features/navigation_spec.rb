require 'rails_helper'
require 'spec_helper'

feature "navigation over application" do
  
  background do
    FactoryGirl.create(:admin)
  end
  
  scenario "admin logs in and navigate in statistics page", :js => true do
    visit "/"
    within '#buttonLogin' do
      click_button 'Login'
    end
    within '#modalLogin' do
      fill_in 'Login', :with => 'admin'
      fill_in 'Password', :with => 'admin'
      click_button 'Login'
    end
    page.should have_content("PAGINA DE PRUEBA")
    click_button "menuButton"
    click_link 'Estadísticas'
    page.should have_content("STATS")
    find(:css, '#Localizacion').click
    page.should have_content("LOCATION")
    find(:css, '#Paginas').click
    page.should have_content("PAGES")
  end
  
end
