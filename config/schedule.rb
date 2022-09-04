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
set :runner_command, "rails runner"
job_type :runner, "cd /usr/share/rvm/rubies/ruby-2.7.2/bin/bundle && bundle exec rails runner -e :environment ':task' :output"

every 1.day, at: '12:00 pm' do
  runner "DailyDigestJob.perform_now"
end

every 30.minutes do
  rake "ts:index"
end
# Learn more: http://github.com/javan/whenever
