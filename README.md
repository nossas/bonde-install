<img
  src="https://avatars2.githubusercontent.com/u/1479357?v=3&s=250"
  alt="Nossas logo"
  title="Nossas"
  align="right"
  height="75"
  width="75"
/>

# Bonde Install
This repository provides scripts to ease the docker development enviroment installation steps of Bonde App.

### Requirements

* Git
* Docker [with Debian](https://docs.docker.com/engine/installation/linux/debian/) and [Mac OSX](https://www.docker.com/products/docker#/mac)
* [Docker Compose](https://docs.docker.com/compose/install/)

```
$ git --version
git version 2.7.4
$ docker -v
Docker version 1.12.5, build 7392c3b
$ docker-compose -v
docker-compose version 1.10.0-rc1, build ecff6f1
```

# Install
```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/install.sh)
```

# Uninstall

```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/uninstall.sh)
```
