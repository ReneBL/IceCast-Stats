class GroupDecorator
	attr_accessor :decorator, :group

	def initialize group, decorator
		@group = group
		@decorator = decorator
	end

	def decorate
		@decorator.decorate group
	end

end

class CountGroupDecorator < GroupDecorator
	def initialize
	end

	def decorate group
		group["$group"].merge!({"count" => {"$sum" => 1}})
	end
end

class TotalSecondsGroupDecorator < GroupDecorator
	def initialize
	end

	def decorate group
		group["$group"].merge!({"count" => {"$sum" => "$seconds_connected"}})
	end
end

class AvgSecondsGroupDecorator < GroupDecorator
	def initialize
	end

	def decorate group
		group["$group"].merge!({"count" => {"$avg" => "$seconds_connected"}})
	end
end