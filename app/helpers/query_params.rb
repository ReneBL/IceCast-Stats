class QueryParams
	attr_accessor :group_by, :unique, :start_date, :end_date, :start_hour, :end_hour

	def initialize (group_by, unique, start_date, end_date, start_hour, end_hour)
		@group_by = group_by
		@unique = unique
		@start_date = start_date
		@end_date = end_date
		@start_hour = start_hour
		@end_hour = end_hour
	end

	def has_hour_filters?
		(@start_hour != nil) && (@end_hour != nil)
	end

	def min_hour_seconds
		hour_seconds @start_hour
	end

	def max_hour_seconds
		hour_seconds @end_hour
	end

	def hour_seconds hour
		h, m, s = hour.split(":")
		(h.to_i * 3600) + (m.to_i * 60) + s.to_i
	end

end