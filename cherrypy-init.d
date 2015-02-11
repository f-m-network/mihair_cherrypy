#!/bin/bash
#
# Basic cherrypy init
#

### BEGIN INIT INFO
# Provides:             cherrypy
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Should-Start:         $network
# Should-Stop:          $network
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Simple Web Framework
# Description:          Simple Web Framework
### END INIT INFO

APP=basic
USER=juan

PY_DIR=/opt/python
PIDFILE=$PY_DIR/pids/cherrypy-$APP.pid
DESC="CherryPy "$APP" Application";  
DAEMON=$PY_DIR/apps/$APP/sysd

[ -x $DAEMON ] || exit 0

#checkpid() {
#    [ -f $PIDFILE ] || return 1
#    pid=`cat $PIDFILE`
#    [ -d /proc/$pid ] && return 0
#    return 1
#}

case "${1}" in
    start)
        echo -n "Starting ${DESC}: "

        start-stop-daemon --start --quiet --pidfile ${PIDFILE} \
            --chuid ${USER} --background  \
            --exec ${DAEMON} 
        echo "Basic has been started successfully"
        ;;

    stop)
        echo -n "Stopping ${DESC}: "

        start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \
            --oknodo

        echo "${NAME}."
        ;;

    restart|force-reload)
        echo -n "Restarting ${DESC}: "

        start-stop-daemon --stop --quiet --pidfile ${PIDFILE} \
            --oknodo
      
        sleep 1

        start-stop-daemon --start --quiet --pidfile ${PIDFILE} \
            --chuid ${USER} --background --make-pidfile \
            --exec ${DAEMON} 

        echo "${NAME}."
        ;;

    *)
        N=/etc/init.d/${NAME}

        echo "Usage: ${NAME} {start|stop|restart|force-reload}" >&2
        exit 1
        ;;

esac
