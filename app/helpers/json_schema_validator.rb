require 'json'
require 'jsonschema'

module JsonSchemaValidator

	def self.valid? data
		schema = File.open("lib/json_schema.json", "rb"){|f| JSON.parse(f.read)}
		JSON::Schema.validate(JSON.parse(data), schema)
	end

end