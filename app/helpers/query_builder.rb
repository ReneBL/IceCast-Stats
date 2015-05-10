class QueryBuilder
	attr_accessor :match, :project, :group_by, :sort, :decorator

	def initialize 
	end

	def add_match match
		@match = match
	end

	def add_project project
		@project = project
	end

	def add_group_by group_by
		@group_by = group_by
	end

	def add_group_decorator decorator
		@decorator = decorator
	end

	def add_sort sort
		@sort = sort
	end

	def add_pagination skip, limit
		@skip = skip
		@limit = limit
	end

	def construct
		filters = []
    filters << (DynamicQueryResolver.match_part @match)
    DynamicQueryResolver.project_totalSeconds_decorator @project
    unwind, group = DynamicQueryResolver.set_unique_if_exists @project, @group_by, decorator
    filters << @project << DynamicQueryResolver.hours_filter << @group_by
   	if ((unwind != nil) && (group != nil))
    	filters << unwind << group
    end
		(@sort == nil) ? filters << DynamicQueryResolver.sort_part : filters << @sort.get
		if (@skip != nil && @limit != nil)
			filters << (DynamicQueryResolver.skip_part @skip) << (DynamicQueryResolver.limit_part @limit)
		end
    filters
	end

end