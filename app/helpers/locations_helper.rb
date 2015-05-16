module LocationsHelper

	def self.project_countries
		{"country" => {"$cond" => [{"$ne" => ["$country", ""]}, "$country", UNKNOWN]}}
	end

	def self.project_regions
		{"region" => {"$cond" => [{"$ne" => ["$region", ""]}, "$region", UNKNOWN]}}
	end

	def self.project_cities
		{"city" => {"$cond" => [{"$ne" => ["$city", ""]}, "$city", UNKNOWN]}}
	end

end