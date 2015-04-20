require 'rails_helper'
require 'spec_helper'

feature "connections between dates" do
  background do
    admin = FactoryGirl.create(:admin)
    FactoryGirl.create(:connection_on_Jan_2014)
    FactoryGirl.create(:connection_on_Feb_2014)
    FactoryGirl.create(:connection_on_Mar_2014)
    FactoryGirl.create(:connection_on_Jan_2015)
  end
  
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
  
  scenario "group results by year, month, or even day", :js => true do
    log_in_process
    visit "/home#/stats"
    page.should have_content("No existen datos para estas fechas")
    page.should_not have_content("Fechas inválidas")
    # fill_in 'fechaFin', :with => Date.new(2000,1,1)
    # page.should have_content("No existen datos para estas fechas")
    # page.should have_content("Fechas inválidas")    
    fill_in 'fechaIni', :with => Date.new(2013,1,1) #'01/01/2013'
    # page.should have_content("No existen datos para estas fechas")
    # page.should have_content("Fechas inválidas")    
    # fill_in 'fechaFin', :with => Date.new(2014,1,1) #'01/01/2014' 
    # page.should have_content("2013")
    # page.should have_content("2014")
#     
    click_button 'Month'
    page.should have_content("01/2013")
    page.should have_content("02/2013")
    page.should have_content("03/2013")
    page.should have_content("01/2014")
#     
    # select '25/03/2013', :from => 'fechaFin'
    # page.should have_content("01/2013")
    # page.should have_content("02/2013")
    # page.should have_content("03/2013")
    # page.should_not have_content("01/2014")
#     
    # select '02/02/2013', :from => 'fechaIni'
    # page.should_not have_content("01/2013")
    # page.should have_content("02/2013")
    # page.should have_content("03/2013")
    # page.should_not have_content("01/2014")
#     
    # click_button 'Year'
    # page.should have_content("2013")
    # page.should_not have_content("2014")
    
    # click_button 'Day'
    # page.should have_content("01/01/2013")
    # page.should have_content("18/01/2013")
    # page.should have_content("02/02/2013")
    # page.should have_content("15/12/2013")
    # page.should have_content("01/01/2014")
  end
  
end
