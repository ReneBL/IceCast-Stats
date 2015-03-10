require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  test "valid connection" do
    conn = build(:connection_ok)
    assert conn.valid?
  end

  test "connection with invalid ip" do
    conn1 = build(:connection_ok)
    conn2 = build(:connection_ok)
    conn3 = build(:connection_ok)
    conn4 = build(:connection_ok)

    conn1.ip = '256.255.255.255'
    conn2.ip = '255.256.255.255'
    conn3.ip = '255.255.256.255'
    conn4.ip = '255.255.255.256'
    assert conn1.invalid? && conn2.invalid? && conn3.invalid? && conn4.invalid?
    assert ["must be a valid ip"] == conn1.errors[:ip] && ["must be a valid ip"] == conn2.errors[:ip] && ["must be a valid ip"] == conn3.errors[:ip] && ["must be a valid ip"] == conn4.errors[:ip]
  end

  test "connection with invalid status" do
    conn = build(:bad_status_connection)
    assert conn.invalid?
    assert_equal ["is invalid"], conn.errors[:status]
  end

  #Valores frontera
  test "connection with seconds and bytes positive" do
    conn = build(:connection_with_seconds_and_bytes_lower_0)
    assert conn.invalid?
    assert_equal ["must be greater than or equal to 0"], conn.errors[:bytes]
    assert_equal ["must be greater than or equal to 0"], conn.errors[:seconds_connected]

    conn.bytes = 0
    conn.seconds_connected = 0
    assert conn.valid?

    conn.bytes = 1
    conn.seconds_connected = 1
    assert conn.valid?
  end

  test "blank connection" do
    conn = build(:blank_connection)
    assert conn.invalid?
    assert_equal ["must be a valid ip"], conn.errors[:ip]
    assert_equal ["can't be blank"], conn.errors[:identd]
    assert_equal ["can't be blank"], conn.errors[:userid]
    assert_equal ["can't be blank"], conn.errors[:datetime]
    assert_equal ["can't be blank"], conn.errors[:request]
    assert_equal ["can't be blank", "is invalid"], conn.errors[:status]
    assert_equal ["can't be blank"], conn.errors[:referrer]
    assert_equal ["can't be blank"], conn.errors[:user_agent]
  end
end
