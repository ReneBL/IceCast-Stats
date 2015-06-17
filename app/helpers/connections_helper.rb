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

module ConnectionsHelper
  
  def self.begin_end_dates_to_mongo start_date, finish_date
  	start_date += ":00:00:00"
    finish_date += ":23:59:59"
    dateStart = DateTime.evolve(DateTime.strptime(start_date, "%d/%m/%Y:%H:%M:%S"))
    dateFinish = DateTime.evolve(DateTime.strptime(finish_date, "%d/%m/%Y:%H:%M:%S"))
    [dateStart, dateFinish]
  end
  
end
