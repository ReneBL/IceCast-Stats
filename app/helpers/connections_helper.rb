module ConnectionsHelper
  
  def self.begin_end_dates_to_mongo start_date, finish_date
    start_date += ":00:00:00"
    finish_date += ":23:59:59"
    dateStart = DateTime.evolve(DateTime.strptime(start_date, "%d/%m/%Y:%H:%M:%S"))
    dateFinish = DateTime.evolve(DateTime.strptime(finish_date, "%d/%m/%Y:%H:%M:%S"))
    [dateStart, dateFinish]
  end
  
end
