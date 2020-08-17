working_directory "/home/meetingup/meetingup/"
pid "/home/meetingup/meetingup/tmp/unicorn.pid"
stderr_path "/home/meetingup/meetingup/log/unicorn.err.log"
stdout_path "/home/meetingup/meetingup/log/unicorn.out.log"

listen "/tmp/meetingup.sock"
worker_processes 2
timeout 30

preload_app true

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Quit the old unicorn process
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
  child_pid = server.config[:pid].sub(".pid", ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end
