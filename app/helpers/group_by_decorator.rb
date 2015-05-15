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

	def initialize name, field=1
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({@name => {"$sum" => @field}})
	end
end

class FirstResultGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name, field
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({@name => {"$first" => @field}})
	end
end

class AvgSecondsGroupDecorator < GroupDecorator
	attr_accessor :name

	def initialize name, field="$seconds_connected"
		@name = name
		@field = field
	end

	def decorate group
		group["$group"].merge!({name => {"$avg" => @field}})
	end
end

# class TotalBytesGroupDecorator < GroupDecorator
# 	attr_accessor :name

# 	def initialize name
# 		@name = name
# 	end

# 	def decorate group
# 		group["$group"].merge!({name => {"$sum" => "$bytes"}})
# 	end
# end