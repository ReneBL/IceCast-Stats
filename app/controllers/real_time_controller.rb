class RealTimeController < ApplicationController

	def last_connections
		date_now = DateTime.evolve(DateTime.now.change(sec: 0))
		filters = []
		hour_interval = get_hour_interval
		match = {"$match" => {"datetime" => {"$gte" => (date_now - hour_interval.hours), "$lte" => date_now}}}
		project = {"$project" => {"datetime" => 1, "listeners" => 1}}
		group_by = {"$group" => {"_id" => {"datetime" => "$datetime", "listeners" => "$listeners"}}}
		sort = {"$sort" => {"_id" => 1}}
		filters << match << project << group_by << sort
		result = ConnectionRealTime.collection.aggregate(filters)
		render :json => result
  end

  private

  def get_hour_interval
  	config = YAML.load_file('config/parser_rt_config.yml')
  	config["real_time_hour_range"]
  end

end