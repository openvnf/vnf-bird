#!/bin/sh

set -e

term() {
	echo "Terminating..."
	exit 0
}

die() {
	echo "$@"
	exit 1
}

set_defaults() {
	true
}

validate_input() {
	true
}

_term() {
    echo "======= caught SIGTERM signal ======="
    birdpid=`pidof bird`
    if [ $? -eq 0 ]; then
        echo "---- kill bird ----"
        kill $birdpid
    fi
    bird6pid=`pidof bird6`
    if [ $? -eq 0 ]; then
        echo "---- kill bird6 ----"
        kill $bird6pid
    fi
    exit 0
}

run_bird() {
	echo "Applying defaults..."
	set_defaults
	echo "Validating input..."
	validate_input

    if [ -f /opt/bird/bird.conf ]; then
        printf ">>> bird configuration >>>>>>>>>>>>>>>>>\n"
        cp /opt/bird/bird.conf /etc/bird/bird.conf
        cat /etc/bird/bird.conf
        printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"
        export BIRD_ENABLED=True
        echo "executing bird daemon..."
        /usr/sbin/bird -d -c /etc/bird/bird.conf -s /var/run/bird/bird.ctl 2>&1 | sed -u 's/.*/birdv4: &/' &
        sleep 1;
    else
        echo "no bird.conf provided at /opt/bird/. bird disabled"
    fi

    if [ -f /opt/bird/bird6.conf ]; then
        printf ">>> bird6 configuration >>>>>>>>>>>>>>>>>\n"
        [ -f /opt/bird/bird6.conf ] && cp /opt/bird/bird6.conf /etc/bird/bird6.conf
        cat /etc/bird/bird6.conf
        printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"
        export BIRD6_ENABLED=True
        echo "executing bird6 daemon..."
        /usr/sbin/bird6 -d -c /etc/bird/bird6.conf -s /var/run/bird/bird6.ctl 2>&1 | sed -u 's/.*/birdv6: &/' &
        sleep 1;
    else
        echo "no bird6.conf provided at /opt/bird/. bird6 disabled"
    fi

	while true; do

        # check if Bird died\
        if [ -n "$BIRD_ENABLED" ]; then
            birdpid=$(pidof bird)
            if [ -z "${birdpid}" ]; then
              for tiktat in $(seq 1 1 10); do
                 echo "No birdpid for last $tiktat seconds"
                 echo "=============\n"
                 date
                 echo "=============\n"
                 ps aux
                 echo "=============\n"
                 sleep 1
                 birdpid=$(pidof bird)
                 if [ -n "${birdpid}" ]; then
                    echo "BIRD PID found and it's $birdpid"
                    break
                 fi
              done
              if [ -z "${birdpid}" ]; then
                  echo "Bird died. Terminating."
                  exit 1
              fi
            fi
        fi

        # check if Bird6 died
        if [ -n "$BIRD6_ENABLED" ]; then
            bird6pid=$(pidof bird6)
            if [ -z "${bird6pid}" ]; then
              for tiktat in $(seq 1 1 10); do
                 echo "No bird6pid for last $tiktat seconds"
                 echo "=============\n"
                 date
                 echo "=============\n"
                 ps aux
                 echo "=============\n"
                 sleep 1
                 bird6pid=$(pidof bird6)
                 if [ -n "${bird6pid}" ]; then
                    echo "BIRD6 PID found and it's $bird6pid"
                    break
                 fi
              done
              if [ -z "${bird6pid}" ]; then
                  echo "Bird died. Terminating."
                  exit 1
              fi
            fi
        fi

        sleep 4
	done
}

[ -n "$ENVFILE" ] && . "$ENVFILE"

trap _term TERM INT

run_bird
exit 0
