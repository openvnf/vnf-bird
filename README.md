# bird routing daemon

This projects provides container images for `bird` version 1.6.8 (bird.network.cz) on ubuntu 20.04.
There are two separate images, one for `bird` and one for `bird6`.

FIB manipulation currently requires some capabilities:

```text
NET_ADMIN, SYS_ADMIN, SETPCAP, NET_RAW
```

## Configuration

Depending on the image, the configuration is done by supplying a `bird.conf`, or respectively, a `bird6.conf`
file in `/opt/bird`.
