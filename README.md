# bird routing daemon

This container image provides bird 1.6.8 (bird.network.cz)
on ubuntu 20.04.

FIB manipulation currently requires some capability:
	NET_ADMIN, SYS_ADMIN, SETPCAP, NET_RAW

### Configuration

Configuration is done by supplying a bird.conf and/or bird6.conf
file(s) in /opt/bird. If a config file is not supplied
on startup, `bird` or `bird6` will not be launched.
