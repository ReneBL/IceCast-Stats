require 'rails_helper'
require 'spec_helper'

# feature 'login admin user' do
#   background do
#     FactoryGirl.create(:admin)
#   end
  
#   scenario 'access the main page', :js => true do
#     visit '/'
#     click_login_welcome_page
#     within '#modalLogin' do
#       fill_form_click 'admin', 'admin'
#     end
#     page.should have_content('Usuario: admin, Logout')
#   end
  
#   scenario 'admin logs in and then logs out', :js => true do
#     visit '/'
#     click_login_welcome_page
#     within '#modalLogin' do
#       fill_form_click 'admin', 'admin'
#     end
#     page.should have_content('Usuario: admin, Logout')
#     click_link 'Logout'
#     page.should have_content('Bienvenid@ a IceCast-Stats')
#     page.should have_content('Login')
#   end
  
#   given(:other_user) { FactoryGirl.build(:not_admin_user) }
  
#   scenario 'access unauthorized login', :js => true do
#     visit '/'
#     click_login_welcome_page
#     within '#modalLogin' do
#       fill_form_click other_user.login, other_user.password
#     end
#     page.should have_content('Inicia sesión en IceCast-Stats')
#     page.should have_content('Login no válido')
#     fill_form_click 'admin', 'admin'
#     page.should have_content('Usuario: admin, Logout')
#   end
  
#   scenario 'access login with incorrect password', :js => true do
#     visit '/'
#     click_login_welcome_page
#     within '#modalLogin' do
#       fill_form_click 'admin', other_user.password
#     end
#     page.should have_content('Inicia sesión en IceCast-Stats')
#     page.should have_content('Password no válida')
#     fill_form_click 'pepe', 'admin'
#     page.should have_content('Login no válido')
#     page.should_not have_content('Password no válida')
#     fill_form_click 'admin', 'admin'
#     page.should have_content('Usuario: admin, Logout')

#   end
  
#   def click_login_welcome_page
#     within '#buttonLogin' do
#       click_button 'Login'
#     end
#   end
  
#   def fill_form_click user, pass
#     fill_in 'Login', :with => user
#     fill_in 'Password', :with => pass
#     click_button 'Login'
#   end
  
# end

# feature "visit protected pages" do
  
#   scenario "unlogged user visit pages" do
#     visit "/home#"
#     page.should have_content("Inicia sesión en IceCast-Stats")
#     visit "/home#/stats"
#     page.should have_content("Inicia sesión en IceCast-Stats")
#   end
  
# end
