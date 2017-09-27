# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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
#job_type :runner, "cd :path && rvm 2.0.0 do bundle exec script/rails runner -e :environment ':task' :output"

every 2.minutes do
  rake "cron:deliver_email"
end

every 5.minutes do
  rake "cron:convert_video"
end

#every 2.minutes do
#	runner 'ApplicationMailer.send_ready_emails'
#end

# Learn more: http://github.com/javan/whenever
