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

feature "country ranking" do

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
    2.times do
      FactoryGirl.create(:connection_from_Spain)
      FactoryGirl.create(:connection_from_Italy)
    end

    3.times do
      FactoryGirl.create(:connection_from_France)
    end

    FactoryGirl.create(:connection_from_China)
    FactoryGirl.create(:connection_from_Germany)
    FactoryGirl.create(:connection_from_United_States)

    admin = FactoryGirl.create(:admin)
    log_in_process
    initial_state
  end

  # OJO!!!! => Para estos tests, cambiar la configuración de la paginación en AngularJS!!!
  scenario "navigate over pages in country ranking", :js => true do

  	fill_in 'fechaIni', :with => Date.new(2014,11,14)

    within '#rankingPais' do
      page.should have_content('Ranking de países')

      page.should have_content('France')
      page.should have_content('3')
      page.should have_content('0h : 0m : 30s')
      page.should have_content('26.3 KB')

      page.should have_content('Spain')
      page.should have_content('2')
      page.should have_content('0h : 0m : 6s')
      page.should have_content('22.7 KB')

      page.should have_content('Italy')
      page.should have_content('2')
      page.should have_content('0h : 2m : 26s')
      page.should have_content('9.07 KB')

      page.should have_content('United States')
      page.should have_content('1')
      page.should have_content('0h : 0m : 20s')
      page.should have_content('2.57 MB')

      page.should have_content('Germany')
      page.should have_content('1')
      page.should have_content('0h : 0m : 18s')
      page.should have_content('42.9 KB')

      page.should_not have_content('China')

      page.should have_content('Siguiente >')
      page.should_not have_content('Anterior >')

      click_button 'botonSiguiente'

      page.should_not have_content('Siguiente >')
      page.should have_content('< Anterior')

      page.should have_content('China')
      page.should have_content('1')
      page.should have_content('0h : 0m : 6s')
      page.should have_content('24.0 KB')

      click_button 'botonAnterior'
      page.should_not have_content('China')
      page.should have_content('France')
      page.should have_content('Spain')
      page.should have_content('United States')
      page.should have_content('Germany')
      page.should have_content('Italy')
    end
  end

  scenario "navigate over pages in country ranking filtering by dates", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,11,14)

    fill_in 'fechaFin', :with => Date.new(2015,3,24)

    within '#rankingPais' do
      page.should have_content('Ranking de países')
      page.should have_content('France')
      page.should have_content('3')
      page.should have_content('0h : 0m : 30s')
      page.should have_content('26.3 KB')

      page.should have_content('Spain')
      page.should have_content('2')
      page.should have_content('0h : 0m : 6s')
      page.should have_content('22.7 KB')

      page.should_not have_content('Italy')
      page.should_not have_content('0h : 2m : 26s')
      page.should_not have_content('9.07 KB')

      page.should have_content('United States')
      page.should have_content('1')
      page.should have_content('0h : 0m : 20s')
      page.should have_content('2.57 MB')

      page.should have_content('Germany')
      page.should have_content('1')
      page.should have_content('0h : 0m : 18s')
      page.should have_content('42.9 KB')

      page.should have_content('China')
      page.should have_content('1')
      page.should have_content('0h : 0m : 6s')
      page.should have_content('24.0 KB') 

      page.should_not have_content('Siguiente >')
      page.should_not have_content('Anterior >')
    
    end

    fill_in 'fechaFin', :with => Date.new(2015,3,25)

    within '#rankingPais' do
      page.should have_content('Siguiente >')
      page.should_not have_content('Anterior >')

      page.should have_content('Italy')
      page.should_not have_content('China')
    end
  end

  scenario "navigate over pages in country ranking filtering by dates", :js => true do
    fill_in 'fechaIni', :with => Date.new(2014,11,14)

    page.should have_content("Siguiente >")

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaInicio', :with => "09:40:02"

    # within '#rankingPais' do
    #   page.should have_content('Italy')
    #   page.should have_content('China')
    #   page.should_not have_content('France')
    #   page.should_not have_content('Spain')
    #   page.should_not have_content('United States')
    #   page.should_not have_content('Germany')

    #   page.should_not have_content("Siguiente >")
    # end

    fill_in 'fechaFin', :with => Date.new(2015,3,24)
    
    within '#rankingPais' do
      page.should_not have_content('Italy')
      page.should have_content('China')
      page.should_not have_content('France')
      page.should_not have_content('Spain')
      page.should_not have_content('United States')
      page.should_not have_content('Germany')
    end

    click_button "dropDownMenu"
    uncheck 'showHourRange'
    within '#rankingPais' do
      page.should_not have_content('Italy')
      page.should have_content('China')
      page.should have_content('France')
      page.should have_content('Spain')
      page.should have_content('United States')
      page.should have_content('Germany')

      page.should_not have_content('Siguiente >')
      page.should_not have_content('< Anterior')
    end

    fill_in 'fechaFin', :with => Date.new(2015,3,25)

    within "#rankingPais" do
      click_button 'botonSiguiente'
      page.should have_content('China')
    end

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaFin', :with => "10:55:41"

    within '#rankingPais' do
      page.should_not have_content('Italy')
      page.should_not have_content('China')
      page.should_not have_content('France')
      page.should_not have_content('Spain')
      page.should_not have_content('United States')
      page.should_not have_content('Germany')
    end

  end
end
