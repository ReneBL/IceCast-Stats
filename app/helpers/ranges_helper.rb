module RangesHelper

	@@MIN = 5
	@@MAX = 120

	def self.min_value
		@@MIN
	end

	def self.max_value
		@@MAX
	end

	# def self.ranges_resolver min, max
	# 		cond = []
	# 		if (min == max)
	# 			# Como descartamos las conexiones menores que 5, nunca podemos dejar que baje de ese limite, sin embargo, puede que, aunque
	# 			# min y max sean iguales y a su vez sean iguales a MAX, se haga el filtro a 3 partes por que no hay limite maximo de duración
	# 			if ((min > @@MIN) && (min <= @@MAX))
	# 				cond.push({"$cond" => [{ "$lt" => ["$seconds_connected", min] }, "rango < " + min.to_s, ""]})
	# 				cond.push({"$cond" => [{ "$eq" => ["$seconds_connected", min] }, "rango = " + min.to_s, ""]})
	# 				cond.push({"$cond" => [{ "$gt" => ["$seconds_connected", min] }, "rango > " + min.to_s, ""]})
	# 				# {"$cond" => [{ "$lte" => ["$seconds_connected", 20] }, "rango 0-20", ""]}, 
 #     #       {"$cond" => [{ "$and" => [{"$gt" => ["$seconds_connected", 20]},{"$lte" => ["$seconds_connected", 60]}]}, "rango 20-60", ""]}, 
 #     #       {"$cond" => [{"$gt" => ["$seconds_connected", 60]}, "rango > 60", "" ]}
	# 			elsif (min == @@MIN)
	# 				cond.push({"$cond" => [{ "$lte" => ["$seconds_connected", min] }, "rango = " + min.to_s, ""]})
	# 				cond.push({"$cond" => [{ "$gt" => ["$seconds_connected", min] }, "rango > " + min.to_s, ""]})
	# 			end
	# 		elsif min == @@MIN
 #      	cond.push({"$cond" => [{ "$lte" => ["$seconds_connected", min] }, "rango = " + min.to_s, ""]})
 #      	cond.push({"$cond" => [{ "$and" => [{"$gt" => ["$seconds_connected", min]},{"$lt" => ["$seconds_connected", max]}]}, "rango " + min.to_s + "-" + max.to_s, ""]})
 #      	cond.push({"$cond" => [{"$gte" => ["$seconds_connected", max]}, "rango >= " + max.to_s, "" ]})
 #    	else
 #    		cond.push({"$cond" => [{ "$lte" => ["$seconds_connected", min] }, "rango <= " + min.to_s, ""]})
 #      	cond.push({"$cond" => [{ "$and" => [{"$gt" => ["$seconds_connected", min]},{"$lt" => ["$seconds_connected", max]}]}, "rango " + min.to_s + "-" + max.to_s, ""]})
 #      	cond.push({"$cond" => [{"$gte" => ["$seconds_connected", max]}, "rango >= " + max.to_s, "" ]})

 #    	end
 #    	cond
 #  end
 def self.ranges_resolver min, max, group
 	group["$group"].merge!({"_id"=> {"$cond"=> [{"$lte"=> ["$seconds_connected", min] },"A: <= " + min.to_s,{"$cond"=> [{"$and"=> [{"$gt"=> ["$seconds_connected", min] },{"$lte"=> ["$seconds_connected", max] }]},"B: " + min.to_s + "-" + max.to_s, {"$cond"=> [{"$gt"=> ["$seconds_connected", max ] },"C: > " + max.to_s, "null"]}]}]}})
 end

end

# db.connections.aggregate(   
# 	{"$match" : {"datetime" : {"$gte" : ISODate("2014-03-27 00:00:00"), "$lte" : ISODate("2014-03-27 23:59:59")}}},   
# 	{"$project" : {"totalSeconds" : {"$add" : [{"$multiply" : [{"$hour" : "$datetime"}, 3600]}, {"$multiply" : [{"$minute" : "$datetime"}, 60]}, 
# 			{"$second" : "$datetime"}]}, "seconds_connected" : 1, "ip" : 1}
# 	},
# 	{"$match" : {"totalSeconds" : {"$gte" : 23224, "$lte" : 30423}}},
# 	{"$group":{"_id": {"$cond": [{"$lte": ["$seconds_connected", 15] },"<= 15",{"$cond": [{"$and": [{"$gt": ["$seconds_connected", 15] },{"$lt": ["$seconds_connected", 60] }]},"15-60",{"$cond": [{"$and": [{"$lt": ["$seconds_connected", 1000] },{"$gte": ["$seconds_connected", 500 ] }]},"Medium","Fast"]}]}]},"count": {"$sum": 1}, "ips" : {"$addToSet" : "$ip"}}}, {"$unwind" : "$ips"},{"$group" : {"_id" : "$_id", "count" : {"$sum" : 1}}} ,{"$sort" : {"_id" : 1}})
