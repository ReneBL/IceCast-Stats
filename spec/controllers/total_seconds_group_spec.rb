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
    
    it "should return 440 seconds of connections between 2014 and 2015" do
      total_seconds_array = [
        { :_id => { :year => 2014 }, :count => 240},
        { :_id => { :year => 2015 }, :count => 200}
      ]
      xhrRequestTotalSecs total_seconds_array, '27/03/2014', '01/01/2015'
    end
    
    
    it "should return total amount of connections in 2014" do 
      total_seconds_array = [
        { :_id => { :year => 2014 }, :count => 240 }
      ]
      xhrRequestTotalSecs total_seconds_array, '27/03/2014', '31/12/2014'
      
      total_seconds_array = [
        { :_id => { :year => 2014 }, :count => 230 }
      ]
      xhrRequestTotalSecs total_seconds_array, '28/03/2014', '31/12/2014'
    end
    
    it "should return empty result" do
      xhrRequestTotalSecs [], '02/01/2015', '02/08/2015'
    end
  end
  
  describe "when pass two dates grouped by month" do
    
    it "should return total seconds grouped by month" do
      total_seconds_array = [
        { :_id => { :year => 2014, :month => 3}, :count => 10},
        { :_id => { :year => 2014, :month => 4}, :count => 50},
        { :_id => { :year => 2014, :month => 10}, :count => 60},
        { :_id => { :year => 2014, :month => 11}, :count => 120},
        { :_id => { :year => 2015, :month => 1}, :count => 200},
      ]
      xhrRequestTotalSecs total_seconds_array, '27/03/2014', '01/01/2015', 'month'
    end
    
    it "should return total seconds on April, October and November" do
      total_seconds_array = [
        { :_id => { :year => 2014, :month => 4}, :count => 30},
        { :_id => { :year => 2014, :month => 10}, :count => 60},
        { :_id => { :year => 2014, :month => 11}, :count => 120}
      ]
      xhrRequestTotalSecs total_seconds_array, '06/04/2014', '11/11/2014', 'month'
    end

    it "should return seconds in November" do
      total_seconds_array = [
        { :_id => { :year => 2014, :month => 11}, :count => 120}
      ]
      xhrRequestTotalSecs total_seconds_array, '11/11/2014', '11/11/2014', 'month'
    end
  end
  
  describe "when pass two dates grouped by day" do
    
    it "should return total seconds grouped by day" do
      total_seconds_array = [
        { :_id => { :year => 2014, :month => 3, :day => 27}, :count => 10},
        { :_id => { :year => 2014, :month => 4, :day => 5}, :count => 20},
        { :_id => { :year => 2014, :month => 4, :day => 15}, :count => 30},
        { :_id => { :year => 2014, :month => 10, :day => 9}, :count => 60},
        { :_id => { :year => 2014, :month => 11, :day => 11}, :count => 120},
        { :_id => { :year => 2015, :month => 1, :day => 1}, :count => 200}
      ]
      xhrRequestTotalSecs total_seconds_array, '27/03/2014', '01/01/2015', 'day'
    end
    
    it "should return seconds in 2015" do
      total_seconds_array = [
        { :_id => { :year => 2015, :month => 1, :day => 01 }, :count => 200}
      ]
      xhrRequestTotalSecs total_seconds_array, '01/01/2015', '01/01/2015', 'day'
    end
  end
  
  describe "when pass invalid data" do
    before(:each) do    
      admin = FactoryGirl.create(:admin)
      log_in(admin)
    end
    
    it "should return invalid date format errors in JSON" do
      error = {"error" => "One date is invalid. Correct format: d/m/Y"}
      xhrRequestTotalSecs error, '18/01/2014/', '010/01/2015'
      xhrRequestTotalSecs error, '01/18/2014', '01/01/2015'
      xhrRequestTotalSecs error, '18/01/2014', '2014/01/03'
    end
    
    it "should return invalid group by option errors in JSON" do
      error = {"error" => "Invalid group by option: try year, month or day"}
      xhrRequestTotalSecs error, '18/01/2014', '01/01/2015', " "
      xhrRequestTotalSecs error, '18/01/2014', '01/01/2015', "true"
    end
    
  end
  
  def xhrRequestTotalSecs(expected_array, st_date='18/01/2014', end_date='01/01/2015', group_by='year')
    expected = expected_array.to_json
    xhr :get, :total_seconds_grouped, :start_date => st_date, :end_date => end_date, 
      :group_by => group_by, :format => :json
    expect(response.body).to eql(expected)
  end

end
