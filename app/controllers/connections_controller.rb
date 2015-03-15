require 'parser'

class ConnectionsController < ApplicationController
 
# db.connections.aggregate({$project : {year : {$year : "$datetime"}}}, {$group : { _id : {year : "$year"}, count : {$sum : 1}}})
  
  def index
    #@result = Connection.where(:datetime.gt => "2013-01-01", :datetime.lt => "2014-01-01")
    result = Connection.collection.aggregate(
        {
          "$project" => {
            'year' => {
              "$year" => "$datetime"
            }
          }
        }, 
        {
          "$group" => {
             '_id' => {
               'year' => "$year"
             }, 
             'count' => {
               "$sum" => 1
             }
          }
        }
    )
    respond_to do |format|
      format.html
      format.json {render :json => result}
    end
  end
  
  def months
    # db.connections.aggregate({$project : {month : {$month : "$datetime"}, year : {$year : "$datetime"}}}, {$match : {year : 2013}}, {$group : { _id : {month : "$month"}, count : {$sum : 1}}}, {$sort : {_id : 1}})
    year = params[:year].to_i
    result = Connection.collection.aggregate(
      {
        "$project" => {
          'month' => {'$month' => '$datetime'},
          'year' => {'$year' => '$datetime'}
        }
      },
      {
        '$match' => {
          'year' => year,
        }
      },
      {
        "$group" => {
          '_id' => {
            'month' => '$month'
          },
          'count' => {
            '$sum' => 1
          }
        }
      },
      {
        "$sort" => {
          '_id' => 1
        }
      }
    )   
    render :json => result
  end
  
  def years
    result = Connection.collection.aggregate(
      {
        "$project" => {
          'year' => {"$year" => "$datetime"}
        }
      }, 
      {
        "$group" => { 
          '_id' => {'year' => "$year"}
         }
      }, 
      {
        "$sort" => {
          '_id' => -1
        }
      })
      render :json => result
  end
  
end