require 'rails_helper'
require 'spec_helper'

feature "avg time" do
  def log_in_form
    visit '/'
    within '#buttonLogin' do
      click_button 'Login'
    end
    within '#modalLogin' do
      fill_in 'Login', :with => 'admin'
      fill_in 'Password', :with => 'admin'
      click_button 'Login'
    end
  end

  def go_to_estadisticas
    click_button "menuButton"
    click_link "Estadísticas"
  end

  background do
    2.times do
    	FactoryGirl.create(:connection_with_5_seconds)
    end
      
    FactoryGirl.create(:connection_with_20_seconds)
    FactoryGirl.create(:connection_with_30_seconds)
    FactoryGirl.create(:connection_with_60_seconds)
    FactoryGirl.create(:connection_with_120_seconds)
    FactoryGirl.create(:connection_with_200_seconds)

    FactoryGirl.create(:admin)
    log_in_form
    go_to_estadisticas
  end

  scenario 'avg time filtered by dates', :js => true do
  	within '#avgTime' do
  		page.should have_content 'No existen datos para estas fechas'
  	end

  	fill_in 'fechaIni', :with => Date.new(2014,3,27)

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content 'Tiempo medio de escucha'
  		page.should have_content '0 horas 1 minutos 3 segundos'
  	end

  	fill_in 'fechaFin', :with => Date.new(2014,12,31)

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 0 minutos 40 segundos'
  	end

  	check 'uniqueVisitors'

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 0 minutos 40 segundos'
  	end
  end

	scenario 'avg time filtered by dates and hours', :js => true do
  	within '#avgTime' do
  		page.should have_content 'No existen datos para estas fechas'
  	end

  	fill_in 'fechaIni', :with => Date.new(2014,3,27)

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 1 minutos 3 segundos'
  	end

  	check 'showHourRange'
  	fill_in 'horaInicio', :with => "06:27:05"

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 1 minutos 18 segundos'
  	end

  	check 'uniqueVisitors'

  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 1 minutos 18 segundos'
  	end

  	fill_in 'horaFin', :with => "12:47:02"
  	within '#avgTime' do
  		page.should_not have_content 'No existen datos para estas fechas'
  		page.should have_content '0 horas 0 minutos 37 segundos'
  	end
  end
  
end