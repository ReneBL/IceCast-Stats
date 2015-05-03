require 'rails_helper'
require 'spec_helper'

feature "connections stats filtered out" do
  # background do
  #   admin = FactoryGirl.create(:admin)
  #   FactoryGirl.create(:source_cuacfm_128k)
  #   FactoryGirl.create(:source_cuacfm_november)
  #   FactoryGirl.create(:source_cuacfm_december)
  #   FactoryGirl.create(:source_pepito)
  # end
  
  # def log_in_process 
  #   visit "/"
  #   within '#buttonLogin' do
  #     click_button 'Login'
  #   end
  #   within '#modalLogin' do
  #     fill_in 'Login', :with => 'admin'
  #     fill_in 'Password', :with => 'admin'
  #     click_button 'Login'
  #   end
  # end

  # scenario 'access the configuration page and select filter', :js => true do
  #   log_in_process
  #   select_filter 'cuacfm.mp3'
  #   page.should have_content("Seleccionado filtro: cuacfm.mp3")
    
  #   go_to_estadisticas
  #   page.should have_content("Filtrando estadísticas por...cuacfm.mp3")

  #   fill_in 'fechaIni', :with => Date.new(2013,1,1)
  #   page.should have_content("2013")
  #   page.should have_content("2")

  #   click_button 'Month'
  #   page.should have_content("11/2013")
  #   page.should have_content("12/2013")

  #   select_filter 'Todos'
  #   go_to_estadisticas
  #   fill_in 'fechaIni', :with => Date.new(2013,1,1)
  #   page.should have_content("Filtrando estadísticas por...Todos")
  #   page.should have_content("2013")
  #   page.should have_content("4")
  # end

  # scenario "check session info deleted", :js => true do
  #   log_in_process
  #   select_filter 'pepito.ogg'
  #   go_to_estadisticas

  #   fill_in 'fechaIni', :with => Date.new(2013,1,1)
  #   page.should have_content("2013")
  #   page.should have_content("1")
  #   page.should have_content("Filtrando estadísticas por...pepito.ogg")
  #   click_button "menuButton"
  #   page.should have_content('Usuario: admin, Logout')
  #   #Hacemos log out
  #   click_link 'Logout'
  #   log_in_process
  #   go_to_estadisticas
  #   page.should have_content("Filtrando estadísticas por...Todos")

  #   fill_in 'fechaIni', :with => Date.new(2013,1,1)
  #   page.should have_content("2013")
  #   page.should have_content("4")
  # end

  # def go_to_estadisticas
  #   click_button "menuButton"
  #   click_link "Estadísticas"
  # end

  # def go_to_config
  #   click_button "menuButton"
  #   click_link "Configuración"
  # end

  # def select_filter source
  #   go_to_config
  #   select source, from: 'comboSources'
  # end

end