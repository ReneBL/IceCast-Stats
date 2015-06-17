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
require 'spec_helper'

feature "total seconds in a period" do

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
    FactoryGirl.create(:connection_with_30_seconds)
    FactoryGirl.create(:connection_with_60_seconds)
    FactoryGirl.create(:connection_with_120_seconds)
    FactoryGirl.create(:connection_with_200_seconds)
      
    FactoryGirl.create(:admin)
    log_in_process
    initial_state
  end

  scenario "show total time connections", :js => true do
    within '#totalTime' do
      page.should_not have_content "Tiempo total de escucha"
      page.should have_content "No existen datos para estas fechas"
    end

    fill_in 'fechaIni', :with => Date.new(2014,3,27)

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 7 minutos 20 segundos"
    end

    click_button "dropDownMenu"
    check 'uniqueVisitors'
    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 7 minutos 20 segundos"
    end

    click_button "dropDownMenu"
    uncheck 'uniqueVisitors'

    fill_in 'fechaFin', :with => Date.new(2014,11,10)    

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 2 minutos 0 segundos"
    end
  end

  scenario "show total time connections filtered by time strip", :js => true do
    within '#totalTime' do
      page.should_not have_content "Tiempo total de escucha"
      page.should have_content "No existen datos para estas fechas"
    end

    fill_in 'fechaIni', :with => Date.new(2014,3,27)

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaInicio', :with => "06:27:05"

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 5 minutos 10 segundos"
    end

    fill_in 'horaFin', :with => "12:47:02"

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 1 minutos 50 segundos"
    end

    click_button "dropDownMenu"
    uncheck 'showHourRange'

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 7 minutos 20 segundos"
    end

    fill_in 'fechaFin', :with => Date.new(2014,12,31)

    within '#totalTime' do
      page.should have_content "Tiempo total de escucha"
      page.should_not have_content "No existen datos para estas fechas"
      page.should have_content "0 horas 4 minutos 0 segundos"
    end    

  end
end