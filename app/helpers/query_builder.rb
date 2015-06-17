=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

class QueryBuilder
	attr_accessor :match, :project, :group_by, :sort, :decorator

	def initialize
		# Ordenación ascendente por defecto
		@sort = SortDecorator.new
		@sort.add "_id", SortCriteria::ASC
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

	def add_extra_unwind unwind
		@unwind_progs = unwind
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
    filters << @project << DynamicQueryResolver.hours_filter
    (filters << @unwind_progs) if (@unwind_progs != nil)
    filters << @group_by
   	if ((unwind != nil) && (group != nil))
    	filters << unwind << group
    end
		filters << @sort.get
		if (@skip != nil && @limit != nil)
			filters << (DynamicQueryResolver.skip_part @skip) << (DynamicQueryResolver.limit_part @limit)
		end
    filters
	end
end
