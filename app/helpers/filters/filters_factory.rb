module FiltersFactory

	def self.get_project_filter
		ProjectFilter.new
	end

	def self.get_group_filter
		GroupFilter.new
	end

	class ProjectFilter

		def initialize
			@project = {"$project" => {}}
		end

		def get_filter
			@project
		end

	end

	class GroupFilter

		def initialize
			@project = {"$group" => {}}
		end

		def get_filter
			@project
		end

	end

end