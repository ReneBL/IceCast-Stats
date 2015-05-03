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
  end

  background do
    2.times do
        FactoryGirl.create(:connection_with_5_seconds)
      end
      
      FactoryGirl.create(:connection_with_20_seconds)
      FactoryGirl.create(:connection_with_60_seconds)
      FactoryGirl.create(:connection_with_120_seconds)
      FactoryGirl.create(:connection_with_200_seconds)
      
      admin = FactoryGirl.create(:admin)
      log_in_process
      initial_state
  end

  # scenario "check errors in input max-min", :js => true do
  #   within "#pieTimeConnections" do
  #     page.should have_content("No existen datos para estas fechas")
  #     fill_in 'min', :with => ''
  #     page.should have_content("No existen datos para estas fechas")
  #     page.should have_content("El valor mínimo no puede ser vacío")

  #     fill_in 'max', :with => ''
  #     page.should have_content("No existen datos para estas fechas")
  #     page.should have_content("El valor mínimo no puede ser vacío")
  #     page.should have_content("El valor máximo no puede ser vacío")

  #     fill_in 'min', :with => '-1'
  #     page.should have_content("No existen datos para estas fechas")
  #     page.should_not have_content("El valor mínimo no puede ser vacío")
  #     page.should have_content("El valor mínimo no es válido (5..120)")
  #     page.should have_content("El valor máximo no puede ser vacío")

  #     fill_in 'max', :with => '250'
  #     page.should have_content("No existen datos para estas fechas")
  #     page.should_not have_content("El valor mínimo no puede ser vacío")
  #     page.should_not have_content("El valor máximo no puede ser vacío")
  #     page.should have_content("El valor mínimo no es válido (5..120)")
  #     page.should have_content("El valor máximo no es válido (5..120)")
  #   end
  # end

  # scenario "range covering all connections", :js => true do
  #   within "#pieTimeConnections" do
  #     page.should have_content("No existen datos para estas fechas")
  #   end
  #   fill_in 'fechaIni', :with => Date.new(2014,3,27)
  #   within "#pieTimeConnections" do
  #     page.should have_content("<= 5")
  #     page.should have_content("5-120")
  #     page.should have_content("> 120")
  #     page.should have_content("33.3%")
  #     page.should have_content("50%")
  #     page.should have_content("16.7%")     
  #   end
  # end

  scenario "changing ranges", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,3,27)
    within "#pieTimeConnections" do
      fill_in 'min', :with => '20'
      page.should have_content("<= 20")
      page.should have_content("20-120")
      page.should have_content("> 120")
      page.should have_content("50%")
      page.should have_content("33.3%")
      page.should have_content("16.7%")
    end
    
    check 'uniqueVisitors'
    within "#pieTimeConnections" do
      page.should have_content("40%")
      page.should have_content("40%")
      page.should have_content("20%")
    end

    uncheck 'uniqueVisitors'
    within "#pieTimeConnections" do
      fill_in 'max', :with => '60'
      page.should have_content("<= 20")
      page.should have_content("20-60")
      page.should have_content("> 60")
      page.should have_content("50%")
      page.should have_content("16.7%")
      page.should have_content("33.3%")
    end
    within "#pieTimeConnections" do
      fill_in 'min', :with => '50'
      page.should have_content("<= 60")
      page.should have_content("> 60")
      page.should have_content("66.6%")
      page.should have_content("33.3%")            
    end
  end

  scenario "changing hours, dates and ranges", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,3,27)
    check 'showHourRange'

    fill_in 'horaInicio', :with => '06:30:04'

    within "#pieTimeConnections" do
      page.should_not have_content("<= 5")
      page.should have_content("5-120")
      page.should have_content("> 120")
      page.should have_content("66.7%")
      page.should have_content("33.3%")
    end
    
    fill_in 'fechaFin', :with => Date.new(2014,12,31)
    
    within "#pieTimeConnections" do
      page.should_not have_content("<= 5")
      page.should have_content("5-120")
      page.should_not have_content("> 120")
      page.should have_content("100%")

      fill_in 'max', :with => '60'
      page.should_not have_content("<= 20")
      page.should have_content("5-50")
      page.should have_content("> 60")
      page.should have_content("50%")
      page.should have_content("50%")         
    end
  end
  
end