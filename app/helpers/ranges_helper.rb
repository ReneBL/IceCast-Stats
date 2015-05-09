module RangesHelper

	@@MIN = 5
	@@MAX = 120

	def self.min_value
		@@MIN
	end

	def self.max_value
		@@MAX
	end

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
