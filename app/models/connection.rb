=begin
IceCast-Stats is system for statistics generation and analysis
for an IceCast streaming server
Copyright (C) 2015  René Balay Lorenzo <rene.bl89@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end

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
  field :city, type: String
  field :region,  type: String
  field :country, type: String
  field :country_code, type: String

  embeds_many :programs

  validates :identd, :userid, :datetime, :request, :status, :bytes, :referrer, :user_agent, 
            :seconds_connected, presence: true
              
  validate :ip_is_valid
      
  validates :status, format: { with: /\A[1-5][0-9][0-9]\z/ }
  validates_numericality_of :bytes, :seconds_connected, greater_than_or_equal_to: 0
  
  def ip_is_valid
    errors.add(:ip, 'must be a valid ip') if (!IPAddress.valid? ip)
  end
end
