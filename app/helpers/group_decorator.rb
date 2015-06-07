class GroupDecorator
	attr_accessor :decorator, :group

	def initialize decorator
		@decorator = decorator
	end

	def decorate group
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

	def initialize name, field=1
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({@name => {"$sum" => @field}})
	end
end

class AvgGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name, field="$seconds_connected"
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({name => {"$avg" => @field}})
	end
end
