# Changelog

## 2.X

### 2.0.0

* separate images for bird and bird6

## 1.X

### 1.2.0

* use Ubuntu 20.04 instead of Fedora
* use latest stable bird 1.6 (1.6.8)

### 1.1.0

* output logs of bird to stdout

### 1.0.2

* install bird6 as it was missing

### 1.0.1

* create `/etc/bird` folder

### 1.0.0

* use Fedora as a base image instead of Ubuntu
* use upstream `bird.network.cz` repository for latest `bird` version

## pre 1.0

### 0.4.0

* disable `bird` or `bird6` if configuration is not provided.

### 0.3.0

* change configuration mount point to `/opt/bird/`, because `/run` and
  `/var/run` are linked and the latter is used by the socket shared with
  another container (two different mount points).

### 0.2.0

* change socket location to `/var/run/bird/`

### 0.1.0

* add first draft for vnf-bird image
