require 'test_helper'

class ConnectionRealTimeTest < ActiveSupport::TestCase
	test "valid connection real time" do
		conn = build(:valid_connection_real_time)
		assert conn.valid?
	end

	test "connection real time with blank fields" do
		conn = build(:connection_real_time_blank_datetime)
		conn2 = build(:connection_real_time_blank_listeners)
		conn3 = build(:connection_real_time_blank)

		assert conn.invalid? && conn2.invalid? && conn3.invalid?
		assert ["can't be blank"] == conn.errors[:datetime] && (conn2.errors[:listeners].include? "can't be blank") &&
			["can't be blank"] == conn3.errors[:datetime] && (conn3.errors[:listeners].include? "can't be blank")
	end

	test "connection real time listeners negative" do
		conn = build(:connection_real_time_negative_listeners)

		assert conn.invalid?
		assert_equal ["must be greater than or equal to 0"], conn.errors[:listeners]
	end
end