# Set the working application directory
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# working_directory "/path/to/your/app"
#working_directory "/var/www/my_app"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{shared_dir}/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "#{shared_dir}/log/unicorn.log"
stdout_path "#{shared_dir}/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.[app name].sock"
listen "/tmp/unicorn.myapp.sock"

# Number of processes
# worker_processes 4
worker_processes 12

# Time-out
timeout 3000