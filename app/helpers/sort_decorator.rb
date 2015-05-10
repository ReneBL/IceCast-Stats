class SortDecorator
	ASC = 1
	DESC = -1

	def initialize
		@sort = {"$sort" => {}}
	end

	def add name, criteria
		@sort["$sort"].merge!({name => criteria})
	end

	def get
		@sort
	end

end