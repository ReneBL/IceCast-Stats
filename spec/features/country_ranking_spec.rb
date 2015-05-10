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
      page.should have_content('30')
      page.should have_content('26298')
      page.should have_content('Spain')
      page.should have_content('2')
      page.should have_content('6')
      page.should have_content('22712')
      page.should have_content('Italy')
      page.should have_content('2')
      page.should have_content('146')
      page.should have_content('9074')
      page.should have_content('United States')
      page.should have_content('1')
      page.should have_content('2567546')
      page.should have_content('20')
      page.should have_content('Germany')
      page.should have_content('1')
      page.should have_content('42890')
      page.should have_content('18')
      page.should_not have_content('China')

      page.should have_content('Siguiente >')
      page.should_not have_content('Anterior >')

      click_button 'botonSiguiente'

      page.should_not have_content('Siguiente >')
      page.should have_content('< Anterior')

      page.should have_content('China')
      page.should have_content('1')
      page.should have_content('6')
      page.should have_content('23978')

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
      page.should have_content('30')
      page.should have_content('26298')
      page.should have_content('Spain')
      page.should have_content('2')
      page.should have_content('6')
      page.should have_content('22712')
      page.should_not have_content('Italy')
      page.should_not have_content('146')
      page.should_not have_content('9074')
      page.should have_content('United States')
      page.should have_content('1')
      page.should have_content('2567546')
      page.should have_content('20')
      page.should have_content('Germany')
      page.should have_content('1')
      page.should have_content('42890')
      page.should have_content('18')
      page.should have_content('China')
      page.should have_content('1')
      page.should have_content('6')
      page.should have_content('23978') 

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

    click_button 'botonSiguiente'
    page.should have_content('China')

    check 'showHourRange'
    fill_in 'horaInicio', :with => "10:55:41"

    within '#rankingPais' do
      page.should have_content('Italy')
      page.should_not have_content('China')
      page.should have_content('France')
      page.should have_content('Spain')
      page.should have_content('United States')
      page.should have_content('Germany')
    end

  end
end
