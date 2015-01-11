eval "$setvar newrelic_init_mysql_plugin" <<'EOF'
#!/bin/bash
#
#
# chkconfig:   2345 80 20
# description: Starts and stops the New Relic MySQL Plugin
# processname: java-newrelic-mysql-plugin

# Source function library.
FUNCTIONS="/etc/init.d/functions"
[ -s "${FUNCTIONS}" ] && . ${FUNCTIONS}

# Program Specific Variables
PROGRAM="newrelic-mysql-plugin"
LOCK_FILE="/var/lock/subsys/${PROGRAM}"
export PID_FILE="/var/run/newrelic/${PROGRAM}.pid"
export user="newrelic"

trap "stop" INT

[[ -f "/etc/sysconfig/$PROGRAM" ]] && . "/etc/sysconfig/$PROGRAM"
if [[ -n $delljre ]] ; then 
    [[ -d "${delljre}/bin/" ]] && PATH=$PATH:${delljre}/bin
fi
# Set this to the plugin directory
[ -z "${PLUGIN_DIR}" ] && PLUGIN_DIR="/usr/local/newrelic-mysql"

# Logging
[ -z "${LOG_DIR}" ] && LOG_DIR="/var/log"
LOG_FILE="${LOG_DIR}/${PROGRAM}.log"

# Java Process
JAVA=`which java 2>/dev/null`
[ -z "${JAVA}" ] && echo "java not found in the PATH" && exit 1

# Plugin Location verification
[ -z "${PLUGIN_DIR}" ] && echo "PLUGIN_DIR must be defined" && exit 2
[ ! -d "${PLUGIN_DIR}" ] && echo "PLUGIN_DIR '${PLUGIN_DIR}' is not a directory" && exit 3

# New Relic MySQL Jar verification
cd ${PLUGIN_DIR}
JAR=`ls *.jar 2>/dev/null | head -1`
[ -z "${JAR}" ] && echo "No New Relic jar found in '${PLUGIN_DIR}'" && exit 4

start() {
        # Start daemons.
        echo "Starting ${PROGRAM}: "
        daemon --pidfile="${PID_FILE}" --user="$user" "${wrapper_executable}" ${JAVA} -Xmx128m -jar ${JAR}
        RETVAL=$?
        [ $RETVAL -eq 0 ] && touch ${LOCK_FILE}
        return $RETVAL
}

stop() {
        echo "Shutting down ${PROGRAM}: "
        [ ! -s "${PID_FILE}" ] && return 0
        killproc -p "${PID_FILE}" "${JAVA}"
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f ${LOCK_FILE} ${PID_FILE} &>/dev/null
        return $RETVAL
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status $PROGRAM
        ;;
  restart|force-reload)
        stop
        start
        ;;
  try-restart|condrestart)
        if status $PROGRAM > /dev/null; then
            stop
            start
        fi
        ;;
  reload)
        exit 3
        ;;
  *)
        echo $"Usage: $0 {start|stop|status|restart|try-restart|force-reload}"
        exit 2
esac
EOF
