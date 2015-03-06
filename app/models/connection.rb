class Connection
  include Mongoid::Document
  field :ip, type: String
  field :identd, type: String
  field :userid, type: String
  field :datetime, type: DateTime
  field :request, type: String
  field :status, type: Integer
  field :bytes, type: Integer
  field :referrer, type: String
  field :user_agent, type: String
  field :seconds_connected, type: Integer
end
