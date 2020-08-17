#!/bin/sh
### BEGIN INIT INFO
# Provides:          sidekiq
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Manage sidekiq server
# Description:       Start and stop sidekiq server for a specific application.
### END INIT INFO
set -e

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT="/home/meetingup/meetingup/"
PID="/home/meetingup/meetingup/tmp/pids/sidekiq.pid"
CMD="cd $APP_ROOT; RAILS_ENV=production bundle exec sidekiq -L log/sidekiq.log -d"
AS_USER=meetingup
set -u

OLD_PIN="$PID.oldbin"

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}

case "$1" in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  run "$CMD"
  ;;
stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
*)
  echo >&2 "Usage: $0 <start|stop>"
  exit 1
  ;;
esac
