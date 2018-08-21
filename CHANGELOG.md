# Changelog
## pre 1.0

### 0.3.0

* change configuration mount point to `/opt/bird/`, because `/run` and
  `/var/run` are linked and the latter is used by the socket shared with
  another container (two different mount points).

### 0.2.0

* change socket location to `/var/run/bird/`

### 0.1.0

* add first draft for vnf-bird image
