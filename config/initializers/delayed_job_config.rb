# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))


# to delete all jobs in the queue.
# rake jobs:clear 

# script/delayed_job can be used to manage a background process which will start working off jobs.
#
# To do so, add gem "daemons" to your Gemfile and make sure you've run rails generate delayed_job.
#
# You can then do the following:
#
# RAILS_ENV=production bin/delayed_job start
# RAILS_ENV=production bin/delayed_job stop
#
# # Runs two workers in separate processes.
# RAILS_ENV=production bin/delayed_job -n 2 start
# RAILS_ENV=production bin/delayed_job stop
