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

	printf ">>> bird configuration >>>>>>>>>>>>>>>>>\n"
	[ -f /run/bird/bird.conf ] && cp /run/bird/bird.conf /etc/bird/bird.conf
	cat /etc/bird/bird.conf
	printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"

	printf ">>> bird6 configuration >>>>>>>>>>>>>>>>>\n"
	[ -f /run/bird/bird6.conf ] && cp /run/bird/bird6.conf /etc/bird/bird6.conf
	cat /etc/bird/bird6.conf
	printf "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"

        echo "executing bird daemon..."
        /usr/sbin/bird -c /etc/bird/bird.conf -s /var/run/bird/bird.ctl
        sleep 1;
        echo "executing bird6 daemon..."
        /usr/sbin/bird6 -c /etc/bird/bird6.conf -s /var/run/bird/bird6.ctl
        sleep 1;

	while true; do
                if ! pidof bird > /dev/null; then
                        echo "Bird died. Terminating."
                        exit 1
                fi

                if ! pidof bird6 > /dev/null; then
                        echo "Bird6 died. Terminating."
                        exit 1
                fi
                sleep 5
	done
}

[ -n "$ENVFILE" ] && . "$ENVFILE"

trap _term TERM INT

run_bird
exit 0
