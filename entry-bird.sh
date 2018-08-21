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
        /usr/sbin/bird -c /etc/bird/bird.conf -s /var/run/bird/bird.ctl
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
        /usr/sbin/bird6 -c /etc/bird/bird6.conf -s /var/run/bird/bird6.ctl
        sleep 1;
    else
        echo "no bird6.conf provided at /opt/bird/. bird6 disabled"
    fi

	while true; do
                if [ -n "$BIRD_ENABLED" ]; then
                    if ! pidof bird > /dev/null; then
                        echo "Bird died. Terminating."
                        exit 1
                    fi
                fi

                if [ -n "$BIRD6_ENABLED" ]; then
                    if ! pidof bird6 > /dev/null; then
                        echo "Bird6 died. Terminating."
                        exit 1
                    fi
                fi
                sleep 5
	done
}

[ -n "$ENVFILE" ] && . "$ENVFILE"

trap _term TERM INT

run_bird
exit 0
