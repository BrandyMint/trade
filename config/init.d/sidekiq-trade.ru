#!/bin/sh
### BEGIN INIT INFO
# Provides:          sidekiq-trade
# Required-Start:    $local_fs $remote_fs $network $time
# Required-Stop:     $local_fs $remote_fs $network
# Should-Start:      $syslog $postgresql $mysql $redis-server
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: online-prodaja.club sidekiq initscript
# Description:       sidekiq
### END INIT INFO

set -e
set -u
APP_USER=${APP_USER:-www}
APP_ENV=${APP_ENV:-production}
APP_ROOT=${APP_ROOT:-/var/www/online-prodaja.club/current}
PIDS_ROOT=/var/www/online-prodaja.club/shared/tmp/pids
PID=${PIDS_ROOT}/sidekiq.pid
TIMEOUT=${TIMEOUT-60}
CMD="cd $APP_ROOT; APP_ROOT=$APP_ROOT RAILS_ENV=$APP_ENV bundle exec sidekiq -C config/sidekiq.yml -d -i 0 -e $APP_ENV -L ${APP_ROOT}/log/sidekiq.log"
action="$1"

cd $APP_ROOT || exit 1

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

my_su () {
   if [ `whoami` != $APP_USER ]; then
      su -l $APP_USER -s /bin/bash -c "$@"
   else
      /bin/bash -l -c "$@"
   fi
}

case $action in
start)
  sig 0 && echo >&2 "Already running" && exit 0
  my_su "$CMD"
  ;;
stop)
  sig QUIT && exit 0
  echo >&2 "Not running"
  ;;
force-stop|force_stop)
  sig TERM && exit 0
  echo >&2 "Not running"
  ;;
restart|reload)
  sig QUIT
  my_su "$CMD"
  ;;
reopen-logs|reopen_logs)
  sig USR1
  ;;
*)
  echo >&2 "Usage: $0 <start|stop|restart>"
  exit 1
  ;;
esac

