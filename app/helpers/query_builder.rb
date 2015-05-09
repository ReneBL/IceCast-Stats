class QueryBuilder
	attr_accessor :match, :project, :group_by, :decorator

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

	def construct
		filters = []
    filters << (DynamicQueryResolver.match_part @match)
    DynamicQueryResolver.project_totalSeconds_decorator @project
    #debugger
    unwind, group = DynamicQueryResolver.set_unique_if_exists @project, @group_by, decorator
    filters << @project << DynamicQueryResolver.hours_filter << @group_by
   	if ((unwind != nil) && (group != nil))
    	filters << unwind << group
    end
    filters << DynamicQueryResolver.sort_part
    filters
	end

end