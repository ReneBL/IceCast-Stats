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

feature 'filter data by time' do
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
      FactoryGirl.create(:connection_at_5_27_on_2013)
    end
    FactoryGirl.create(:connection_at_7_19_on_2013)
    FactoryGirl.create(:connection_at_8_45_on_2014)
    FactoryGirl.create(:admin)
    log_in_form
    go_to_estadisticas
  end
  
  scenario 'bad hours format', :js => true do
    page.should_not have_content("Desde las")
    page.should_not have_content("hasta las")

    click_button "dropDownMenu"
    check 'showHourRange'

    page.should have_content("Desde las")
    page.should have_content("hasta las")

    fill_in 'horaInicio', :with => "010:30:189"
    page.should have_content("Hora inicio no válida")

    fill_in 'horaFin', :with => "25:30:18"
    page.should have_content("Hora inicio no válida")
    page.should have_content("Hora fin no válida")

    fill_in 'horaInicio', :with => "10:30:18"
    page.should_not have_content("Hora inicio no válida")
    page.should have_content("Hora fin no válida")

    fill_in 'horaFin', :with => "15:45:09"
    page.should_not have_content("Hora inicio no válida")
    page.should_not have_content("Hora fin no válida")

    fill_in 'horaInicio', :with => "13:30:18"
    page.should_not have_content("Hora inicio no válida")
    page.should_not have_content("Hora fin no válida")

    fill_in 'horaFin', :with => "12:45:09"
    page.should_not have_content("Hora inicio no válida")
    page.should_not have_content("Hora fin no válida")
    page.should have_content("La hora de inicio es mayor que la hora de fin")

    fill_in 'horaInicio', :with => ""
    page.should have_content("Hora inicio no válida")
    page.should_not have_content("La hora de inicio es mayor que la hora de fin")

    fill_in 'horaFin', :with => ""
    page.should have_content("Hora inicio no válida")
    page.should have_content("Hora fin no válida")

    # Por defecto la opción de agrupamiento es por año, así que comprobamos que no se ha pintado ninguna gráfica
    within '#cgcController' do
      page.should_not have_content("2013")
      page.should_not have_content("2014")
    end
  end
  
  scenario 'wide filters, hour in range', :js => true do
    fill_in 'fechaIni', :with => Date.new(2013,1,1)

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaInicio', :with => "05:27:04"
    fill_in 'horaFin', :with => "08:45:31"

    within "#cbdYear" do
      page.should have_content("2013")
      page.should_not have_content("2014")
    end

    within "#cgcController" do
      click_button 'Mes'
      within "#cbdMonth" do
        page.text.should match("11/2013")
        page.text.should match("12/2013")
        page.text.should_not match("1/2014")
      end
    end
  end

  scenario 'wide dates, hour in/out of range', :js => true do
    FactoryGirl.create(:connection_at_10_07_on_2013)

    fill_in 'fechaIni', :with => Date.new(2013,1,1)

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaInicio', :with => "08:45:33"
    fill_in 'horaFin', :with => "05:27:03"

    # La pagina contendrá 2013 y 2014 porque al ser las horas no válidas, no recarga la gráfica
    within '#cgcController' do
      page.should have_content("2013")
      page.should have_content("2014")
    end
    page.should have_content("La hora de inicio es mayor que la hora de fin")

    fill_in 'horaFin', :with => "10:07:58"
    page.should_not have_content("La hora de inicio es mayor que la hora de fin")

    within '#cgcController' do
      page.should have_content("No existen datos para estas fechas")
      page.should_not have_content("2013")
      page.should_not have_content("2014")
    end

    fill_in 'horaFin', :with => "10:07:59"
    within "#cbdYear" do
      page.should have_content("2013")
    end

    click_button 'Mes'
    within "#cbdMonth" do
      page.text.should match("11/2013")
    end

    # Desmarcamos el check
    click_button "dropDownMenu"
    uncheck 'showHourRange'
    page.text.should match("11/2013")
    page.text.should match("12/2013")
    page.text.should match("1/2014")

    # Lo volvemos a marcar
    click_button "dropDownMenu"
    check 'showHourRange'
    page.text.should match("11/2013")
    page.text.should_not match("12/2013")
    page.text.should_not match("1/2014")

    fill_in 'horaInicio', :with => "08:45:32"

    within "#cbdMonth" do
      page.text.should match("11/2013")
      page.text.should match("1/2014")
    end
  end

  scenario "dates and hour range change", :js => true do
    fill_in 'fechaIni', :with => Date.new(2013,12,14)
    fill_in 'fechaFin', :with => Date.new(2013,12,14)

    # La franja horaria por defecto es desde las 00:00:00 hasta las 23:59:59
    within "#cgcController" do
      click_button 'Mes'
    end

    # Comprobamos que, aunque tenga un filtro de horas que abarque todo el día, solo
    # nos representa las estadísticas en la fecha marcada
    within "#cgcController" do
      within "#cbdMonth" do
        page.text.should match("12/2013")
      end
    end

    fill_in 'fechaFin', :with => Date.new(2014,1,1)
    within "#cbdMonth" do
      page.text.should match("12/2013")
      page.text.should match("1/2014")
    end

    click_button "dropDownMenu"
    check 'showHourRange'
    fill_in 'horaFin', :with => "08:45:31"
    within "#cbdMonth" do
      page.text.should match("12/2013")
    end
  end  
end