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

feature "region ranking" do

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
    find(:css, '#Ranking').click
  end

  background do
    3.times do
      FactoryGirl.create(:connection_from_Galicia)
    end
    FactoryGirl.create(:connection_from_Madrid)

    2.times do
      FactoryGirl.create(:connection_from_Extremadura)
    end

    3.times do
      FactoryGirl.create(:connection_from_Cataluña)
    end

    FactoryGirl.create(:connection_from_New_Jersey)
    FactoryGirl.create(:connection_from_Nacional)
      
    admin = FactoryGirl.create(:admin)
    log_in_process
    initial_state
  end

  # OJO!!!! => Para estos tests, cambiar la configuración de la paginación en AngularJS!!!
  scenario "navigate over pages in region ranking", :js => true do

  	fill_in 'fechaIni', :with => Date.new(2014,07,17)

    within '#rankingRegion' do
      page.should have_content('Ranking de regiones')

      page.should have_content('Galicia, Spain')
      page.should have_content('3')
      page.should have_content('330 Bytes')
      page.should have_content('0h : 0m : 30s')

      page.should have_content('Cataluña, Spain')
      page.should have_content('3')
      page.should have_content('75.0 Bytes')
      page.should have_content('0h : 1m : 0s')
      
      page.should have_content('Extremadura, Spain')
      page.should have_content('2')
      page.should have_content('200 Bytes')
      page.should have_content('0h : 0m : 30s')

      page.should have_content('Madrid, Spain')
      page.should have_content('1')
      page.should have_content('23.0 Bytes')
      page.should have_content('0h : 0m : 8s')

      page.should have_content('New Jersey, United States')
      page.should have_content('1')
      page.should have_content('23.0 Bytes')
      page.should have_content('0h : 0m : 9s')
      
      page.should_not have_content('Nacional, Dominican Republic')

      page.should have_content('Siguiente >')
      page.should_not have_content('Anterior >')

      click_button 'botonSiguiente'

      page.should_not have_content('Siguiente >')
      page.should have_content('< Anterior')

      page.should have_content('Nacional, Dominican Republic')
      page.should have_content('1')
      page.should have_content('16')
      page.should have_content('23')

      click_button 'botonAnterior'
      page.should_not have_content('Nacional, Dominican Republic')
      page.should have_content('Galicia, Spain')
      page.should have_content('Cataluña, Spain')
      page.should have_content('Extremadura, Spain')
      page.should have_content('Madrid, Spain')
      page.should have_content('New Jersey, United States')
    end
  end

  scenario "navigate over pages in region ranking filtering by dates", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,07,17)

    fill_in 'fechaFin', :with => Date.new(2015,2,24)

    within '#rankingRegion' do
    	page.should have_content('Ranking de regiones')

      page.should have_content('Galicia, Spain')
      page.should have_content('3')
      page.should have_content('330 Bytes')
      page.should have_content('0h : 0m : 30s')

      page.should have_content('Cataluña, Spain')
      page.should have_content('3')
      page.should have_content('75.0 Bytes')
      page.should have_content('0h : 1m : 0s')
      
      page.should have_content('Extremadura, Spain')
      page.should have_content('2')
      page.should have_content('200 Bytes')
      page.should have_content('0h : 0m : 30s')
      
      page.should have_content('Madrid, Spain')
      page.should have_content('1')
      page.should have_content('23.0 Bytes')
      page.should have_content('0h : 0m : 8s')
      
      page.should have_content('New Jersey, United States')
      page.should have_content('1')
      page.should have_content('23.0 Bytes')
      page.should have_content('0h : 0m : 9s')

      page.should_not have_content('Siguiente >')
      page.should_not have_content('Anterior >')
    
    end

    fill_in 'fechaFin', :with => Date.new(2015,2,25)

    within '#rankingRegion' do
      page.should have_content('Siguiente >')
      page.should_not have_content('Anterior >')
    end
  end

  scenario "navigate over pages in region ranking filtering by dates", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,7,17)

    page.should have_content("Siguiente >")

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaInicio', :with => "02:27:05"

    within '#rankingRegion' do
    	page.should_not have_content('Galicia, Spain')
      page.should have_content('Cataluña, Spain')
      page.should have_content('Extremadura, Spain')
      page.should have_content('Madrid, Spain')
      page.should have_content('New Jersey, United States')
      page.should have_content('Nacional, Dominican Republic')

      page.should_not have_content("Siguiente >")
    end

    fill_in 'fechaFin', :with => Date.new(2015,2,24)
    
    within '#rankingRegion' do
      page.should_not have_content('Galicia, Spain')
      page.should_not have_content('Nacional, Dominican Republic')
      page.should have_content('Cataluña, Spain')
      page.should have_content('Extremadura, Spain')
      page.should have_content('Madrid, Spain')
      page.should have_content('New Jersey, United States')
    end

    click_button "dropDownMenu"
    uncheck 'showHourRange'
    within '#rankingRegion' do
      page.should have_content('Galicia, Spain')
      page.should have_content('Cataluña, Spain')
      page.should have_content('Extremadura, Spain')
      page.should have_content('Madrid, Spain')
      page.should have_content('New Jersey, United States')
      page.should_not have_content('Nacional, Dominican Republic')

      page.should_not have_content('Siguiente >')
      page.should_not have_content('< Anterior')
    end
  end

  scenario "check one unique result", :js => true do
  	fill_in 'fechaIni', :with => Date.new(2014,7,17)
  	fill_in 'fechaFin', :with => Date.new(2015,3,25)

    click_button "dropDownMenu"
  	check 'showHourRange'
    fill_in 'horaInicio', :with => "00:27:05"
    fill_in 'horaFin', :with => "03:10:39"

    within '#rankingRegion' do
      page.should have_content('Cataluña, Spain')
      page.should_not have_content('Galicia, Spain')
      page.should_not have_content('Extremadura, Spain')
      page.should_not have_content('Madrid, Spain')
      page.should_not have_content('New Jersey, United States')
      page.should_not have_content('Nacional, Dominican Republic')

      page.should_not have_content('Siguiente >')
      page.should_not have_content('< Anterior')
    end
  end
end
