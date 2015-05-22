# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, "#{Rails.root}/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 3.minutes do
	runner "ParserRT.automatic_start"
end

every :day, :at => '21:50 pm' do
	runner "Parser.parse_without_path"
end

# Learn more: http://github.com/javan/whenever
