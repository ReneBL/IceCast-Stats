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

class CompositeGroupDecorator < GroupDecorator
	attr_accessor :childs

	def initialize
		@childs = []
	end

	def add group_decorator
		@childs << group_decorator
	end

	def decorate group
		@childs.each do |child|
			child.decorate group
		end
	end
end

class CountGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name
		@name = name
	end

	def decorate group
		group["$group"].merge!({name => {"$sum" => 1}})
	end
end

class TotalSecondsGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name
		@name = name
	end

	def decorate group
		group["$group"].merge!({name => {"$sum" => "$seconds_connected"}})
	end
end

class AvgSecondsGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name
		@name = name
	end

	def decorate group
		group["$group"].merge!({name => {"$avg" => "$seconds_connected"}})
	end
end

class TotalBytesGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name
		@name = name
	end

	def decorate group
		group["$group"].merge!({name => {"$sum" => "$bytes"}})
	end
end