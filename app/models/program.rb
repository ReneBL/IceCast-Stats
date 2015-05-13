class Program
	include Mongoid::Document

	field :name, type: String
	field :seconds_listened, type: Integer
	embedded_in :connection
end