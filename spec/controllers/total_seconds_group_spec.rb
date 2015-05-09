require 'rails_helper'
require 'json'

RSpec.describe ConnectionsController, type: :controller do

  before(:each) do
    2.times do
      FactoryGirl.create(:connection_with_5_seconds)
    end
      
    FactoryGirl.create(:connection_with_20_seconds)
    FactoryGirl.create(:connection_with_30_seconds)
    FactoryGirl.create(:connection_with_60_seconds)
    FactoryGirl.create(:connection_with_120_seconds)
    FactoryGirl.create(:connection_with_200_seconds)
      
    admin = FactoryGirl.create(:admin)
    log_in(admin)
  end
  
  describe "when pass two dates grouped by year" do
    
    it "should return 4 connections in 2014" do
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 4 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestTotalSecs connections_between_dates_year, '01/01/2014', '25/03/2014'
      xhrRequestTotalSecs connections_between_dates_year, '18/01/2014', '28/03/2014'
    end
    
    
    it "should return 2 connections in 2014" do 
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 2 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestTotalSecs connections_between_dates_year, '19/01/2014', '25/03/2014'
      
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 3 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestTotalSecs connections_between_dates_year, '01/01/2014', '24/03/2014'
    end
    
    it "should return 5 connections: 2014 and 2015" do 
      connections_between_dates_year_array = [
        { :_id => { :year => 2014 }, :count => 4 },
        { :_id => { :year => 2015 }, :count => 1 }
      ]
      connections_between_dates_year = connections_between_dates_year_array.to_json
      xhrRequestTotalSecs connections_between_dates_year, '01/01/2014', '02/08/2015'
    end
  end
  
  describe "when pass two dates grouped by month" do
    
    it "should return 2 connections on January and in February of 2014" do
      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 2},
        { :_id => { :year => 2014, :month => 2}, :count => 1}
      ]
      connections_between_dates_month = connections_between_dates_month_array.to_json
      xhrRequestTotalSecs connections_between_dates_month, '01/01/2014', '20/02/2014', 'month'
    end
    
    it "should return 2 connections on January, 1 in February of 2014, and 1 in January of 2015" do
      connections_between_dates_month_array = [
        { :_id => { :year => 2014, :month => 1}, :count => 2},
        { :_id => { :year => 2014, :month => 2}, :count => 1},
        { :_id => { :year => 2015, :month => 1}, :count => 1}
      ]
      connections_between_dates_month = connections_between_dates_month_array.to_json
      xhrRequestTotalSecs connections_between_dates_month, '03/01/2014', '01/01/2015', 'month'
    end
  end
  
  describe "when pass two dates grouped by day" do
    
    it "should return 2 connections on 18/01/2014, 2 on 19/02/2014, and 1 in 25/03/2014" do
      connections_between_dates_day_array = [
        { :_id => { :year => 2014, :month => 1, :day => 18}, :count => 2},
        { :_id => { :year => 2014, :month => 2, :day => 19 }, :count => 2},
        { :_id => { :year => 2014, :month => 3, :day => 25 }, :count => 1}
      ]
      connections_between_dates_day = connections_between_dates_day_array.to_json
      xhrRequestTotalSecs connections_between_dates_day, '18/01/2014', '25/03/2014', 'day'
    end
    
    it "should return 2 connections on 18/01/2014, 2 on 19/02/2014, 1 on 25/03/2014 and 1 on 01/01/2015" do
      connections_between_dates_day_array = [
        { :_id => { :year => 2014, :month => 1, :day => 18 }, :count => 2},
        { :_id => { :year => 2014, :month => 2, :day => 19 }, :count => 2},
        { :_id => { :year => 2014, :month => 3, :day => 25 }, :count => 1},
        { :_id => { :year => 2015, :month => 1, :day => 01 }, :count => 1}
      ]
      connections_between_dates_day = connections_between_dates_day_array.to_json
      xhrRequestTotalSecs connections_between_dates_day, '18/01/2014', '01/01/2015', 'day'
    end
  end
  
  describe "when pass invalid data" do
    before(:each) do    
      admin = FactoryGirl.create(:admin)
      log_in(admin)
      
      errorDateHash = {"error" => "One date is invalid. Correct format: d/m/Y"}
      @errorDate = errorDateHash.to_json
      
      errorGroupHash = {"error" => "Invalid group by option: try year, month or day"}
      @errorGroup = errorGroupHash.to_json
    end
    
    it "should return invalid date format errors in JSON" do
      xhrRequestTotalSecs @errorDate, '18/01/2014/', '010/01/2015'
      xhrRequestTotalSecs @errorDate, '01/18/2014', '01/01/2015'
      xhrRequestTotalSecs @errorDate, '18/01/2014', '2014/01/03'
    end
    
    it "should return invalid group by option errors in JSON" do
      xhrRequestTotalSecs @errorGroup, '18/01/2014', '01/01/2015', " "
      xhrRequestTotalSecs @errorGroup, '18/01/2014', '01/01/2015', "true"
      expect(response.body).to eql(@errorGroup)
    end
    
  end
  
  def xhrRequestTotalSecs(expected, st_date='18/01/2014', end_date='01/01/2015', group_by='year')
    xhr :get, :total_seconds_grouped, :start_date => st_date, :end_date => end_date, 
      :group_by => group_by, :format => :json
    expect(response.body).to eql(expected)
  end

end
