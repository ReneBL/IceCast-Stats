###################################################################################
#IceCast-Stats is system for statistics generation and analysis
#for an IceCast streaming server
#Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
###################################################################################

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