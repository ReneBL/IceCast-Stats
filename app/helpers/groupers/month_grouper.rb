class MonthGrouper < Grouper

	def initialize qp, match_session
		@qp = qp
		@match = match_session
	end

	def project_part
		project = FiltersFactory.get_project_filter
		project["$project"] = {"year" => {"$year" => "$datetime"}, "month" => {"$month" => "$datetime"}, "datetime" => 1}
		if @qp.has_hour_filter?
			project.extend(HourDecorator)
		end
		if @qp.unique
			project.extend(UniqueDecorator)
		end
		project
	end

	def group_part
		group = FiltersFactory.get_group_filter
		project["$group"] = {"$group" => { "_id" => {"year" => "$year", "month" => "$month"}}}
		if @qp.unique
			project.extend(UniqueDecorator)
		else
			# AÑADIR A HASH LO QUE SEA
			project["$group"] = {"$group" => { "_id" => {"year" => "$year"}}}
		end
	end

end