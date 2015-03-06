json.array!(@connections) do |connection|
  json.extract! connection, :id, :ip, :identd, :userid, :datetime, :request, :status, :bytes, :referrer, :user_agent, :seconds_connected
  json.url connection_url(connection, format: :json)
end
