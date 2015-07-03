# Change to match your CPU core count
workers 2

# Min and Max threads per worker
threads 1, 20

#pre load application
preload_app!


app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

stdout_redirect "#{Dir.pwd}/log/puma.stdout.log", "#{Dir.pwd}/log/puma.stderr.log", true

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
 stdout_redirect '#{shared_dir}/log/stdout', '#{shared_dir}/log/stderr'
 stdout_redirect '#{shared_dir}/log/stdout', '#{shared_dir}/log/stderr', true

# Disable request logging.
#
# The default is "false".
#
# quiet

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
bind  "unix://#{shared_dir}socket/puma.sock"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
