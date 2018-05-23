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

Our development setup could be started by two ways, using vagrant or with local docker.

To provision services using VirtualBox and Vagrant, we recomend the following versions:
* VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html

If you want to start containers locally:
* Docker ( required 17.10.0-ce or later ) - https://docs.docker.com/install/
* Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
* Make ( optional: 3.81 ) - https://www.gnu.org/software/make/

# Install
In the first scenario:
```
sudo vagrant plugin install vagrant-hostmanager
vagrant up
```

Or to the second:

```
make migrate
make start
```

We have some extra services used in production to monitor, log and analyze containers. To enable, just type:

```
make extras
```

Add to ```/etc/hosts``` following line:

```127.0.0.1 consul.bonde.devel smtp.bonde.devel traefik.bonde.devel s3.bonde.devel grafana.bonde.devel prometheus.bonde.devel api-v1.bonde.devel api-v2.bonde.devel kibana.bonde.devel fn-ui.bonde.devel app.bonde.devel weave.bonde.devel bonde.devel concourse.bonde.devel ```

# Generate self-signed certificates

https://stackoverflow.com/a/15076602/397927
https://gist.github.com/kyledrake/d7457a46a03d7408da31

# Easy Install
```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/install.sh)
```

# Uninstall

```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/uninstall.sh)
```

Additional Resources:

* Rancher CLI - https://rancher.com/docs/rancher/latest/en/cli/
* Drone CLI - http://docs.drone.io/cli-installation/
* Fly CLI - https://concourse-ci.org/fly.html
* Fn CLI - https://github.com/fnproject/cli/releases/
