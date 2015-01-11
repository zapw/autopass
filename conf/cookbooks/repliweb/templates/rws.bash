eval "$setvar rws" <<'EOF'
#!/bin/sh
#
# rws          starts and stops repliweb_scheduler service.
#
# chkconfig: 2345 90 60
# description: repliweb_scheduler daemon

### BEGIN INIT INFO
# Provides: repliweb_scheduler
# Required-Start: $local_fs $syslog
# Required-Stop: $local_fs $syslog
# Default-Start:  2345
# Default-Stop: 90
# Short-Description: run repliweb_scheduler daemon
# Description: repliweb scheduler
### END INIT INFO



# /etc/rc.d/init.d/rws - starts and stops repliweb_scheduler service.

# Symbolic Links to this file should be created in the appropriate rc(x).d
# directories.


# Source function library.
. /etc/rc.d/init.d/functions


# See how we were called.
case "$1" in
  start)
    if [[ ! -f /var/lock/subsys/rws ]] ; then
        echo -n "Starting repliweb_scheduler service: "
        repliweb_scheduler start
        echo
    else
        echo "repliweb_scheduler service: running, run $0 stop"
    fi
    touch /var/lock/subsys/rws
    ;;
  stop)
    echo -n "Shutting down repliweb_scheduler service: "
    repliweb_scheduler -stop
    rm -f /var/lock/subsys/rws
    echo ""
    ;;
  *)
    echo "Usage: repliweb_scheduler {start|stop}"
    exit 1
esac
EOF
