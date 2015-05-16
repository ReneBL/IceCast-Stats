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
