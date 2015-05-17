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
      page.should have_content('30')
      page.should have_content('330')

      page.should have_content('Cataluña, Spain')
      page.should have_content('3')
      page.should have_content('60')
      page.should have_content('75')
      
      page.should have_content('Extremadura, Spain')
      page.should have_content('2')
      page.should have_content('30')
      page.should have_content('200')

      page.should have_content('Madrid, Spain')
      page.should have_content('1')
      page.should have_content('2567546')
      page.should have_content('20')

      page.should have_content('New Jersey, United States')
      page.should have_content('1')
      page.should have_content('9')
      page.should have_content('23')
      
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
      page.should have_content('30')
      page.should have_content('330')

      page.should have_content('Cataluña, Spain')
      page.should have_content('3')
      page.should have_content('60')
      page.should have_content('75')
      
      page.should have_content('Extremadura, Spain')
      page.should have_content('2')
      page.should have_content('30')
      page.should have_content('200')
      
      page.should have_content('Madrid, Spain')
      page.should have_content('1')
      page.should have_content('2567546')
      page.should have_content('20')
      
      page.should have_content('New Jersey, United States')
      page.should have_content('1')
      page.should have_content('9')
      page.should have_content('23')

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

    check 'showHourRange'
    fill_in 'horaInicio', :with => "00:27:05"

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

    uncheck 'showHourRange'
    within '#rankingRegion' do
      page.should have_content('Galicia, Spain')
      page.should have_content('Cataluña, Spain')
      page.should have_content('Extremadura, Spain')
      page.should have_content('Madrid, Spain')
      page.should have_content('New Jersey, United States')
      page.should have_content('Nacional, Dominican Republic')

      page.should_not have_content('Siguiente >')
      page.should_not have_content('< Anterior')
    end
  end

  scenario "check one unique result", :js => true do
  	fill_in 'fechaIni', :with => Date.new(2014,7,17)
  	fill_in 'fechaFin', :with => Date.new(2015,3,25)

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