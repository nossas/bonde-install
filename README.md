<img
  src="https://avatars2.githubusercontent.com/u/1479357?v=3&s=250"
  alt="Nossas logo"
  title="Nossas"
  align="right"
  height="75"
  width="75"
/>

# Bonde Install
This repository provides scripts to ease the development. To do that, configurations  are abstracted to containers with docker.

## Requirements

Our development setup could be started by two ways, using vagrant or with local docker.

If you only want to start containers locally:
* Docker ( required 17.10.0-ce or later ) - https://docs.docker.com/install/
* Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
* Make ( optional: 3.81 ) - https://www.gnu.org/software/make/

To provision services using VirtualBox and Vagrant, we recomend the following versions:
* VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html


## How to

Running the commands will result in downloading a big amount of gigabytes, and some commands will demand  high levels of usage from cpu:

```
mkdir bonde
cd bonde
git clone git@github.com:nossas/bonde-install.git
cd bonde-install
make begin
```

**Important**: In case of problems when running make begin run make clean and try again

Add to ```/etc/hosts``` following lines:

```

127.0.0.1   api-v3.bonde.devel traefik.bonde.devel bonde.devel app.bonde.devel admin-canary.bonde.devel api-v1.bonde.devel api-v2.bonde.devel teste.bonde.devel

127.0.0.1 3-vamos-limpar-o-tiete.bonde.devel 2-save-the-whales.bonde.devel 1-vamos-limpar-o-tiete.bonde.devel
```

These are essentials URLs from BONDE and must be accessible to get local copy fully working:

* api-v1.bonde.devel
* api-v2.bonde.devel
* app.bonde.devel
* admin-canary.bonde.devel
* 1-vamos-limpar-o-tiete.bonde.devel
* 2-save-the-whales.bonde.devel
* 3-vamos-limpar-o-tiete.bonde.devel
* teste.bonde.devel

If you want to test mail and s3 integrations used by our modules, you should run:

```make extras```

* fake-s3.bonde.devel
* fake-smtp.bonde.devel
* traefik.bonde.devel

### Dispatchers

#### Notifications

Check if templates and jwt_secret are added to database after migrations synced.

To Run:

```docker-compose up -d notifications```

## Check

Congratulations, when command finished of running, you could check if everything are ok running ```make status```, you should see a table like the following:

```
           Name                          Command                  State                                                      Ports
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
bonde-install_admin_1         yarn start                       Up             0.0.0.0:32770->5001/tcp
bonde-install_api-v1_1        bundle exec puma -C config ...   Up             3000/tcp
bonde-install_api-v2_1        npm run dev                      Up
                                                                              0.0.0.0:8400->8400/tcp, 0.0.0.0:8500->8500/tcp
bonde-install_pgmaster_1      docker-entrypoint.sh /usr/ ...   Up             22/tcp, 0.0.0.0:5444->5432/tcp
bonde-install_pgpool_1        /usr/local/bin/pgpool/entr ...   Up (healthy)   22/tcp, 0.0.0.0:5432->5432/tcp, 9898/tcp
bonde-install_public_1        yarn start                       Up
bonde-install_s3_1            /usr/bin/docker-entrypoint ...   Up (healthy)   0.0.0.0:9000->9000/tcp
bonde-install_smtp_1          MailHog                          Up             0.0.0.0:1025->1025/tcp, 0.0.0.0:8025->8025/tcp
bonde-install_traefik_1       /traefik --consul --consul ...   Up             0.0.0.0:32772->443/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:8080->8080/tcp
             Name                            Command               State     Ports
------------------------------------------------------------------------------------
bonde-install_bot-worker_1        npm run start:worker             Up
bonde-install_mailchimp_1         bundle exec sidekiq -c 5 - ...   Up       3000/tcp
bonde-install_mailers_1           bundle exec sidekiq -q def ...   Up       3000/tcp
bonde-install_migrations_1        bundle exec rake db:migrate      Exit 0
bonde-install_seeds_1             bundle exec rake db:seed         Exit 0
bonde-install_templates-email_1   bundle exec rake notificat ...   Exit 1
                 Name                                Command               State                 Ports
--------------------------------------------------------------------------------------------------------------------
bonde-install_dispatcher-domain_1         /bin/sh -c ./run_dispatche ...   Up
bonde-install_dispatcher-notification_1   /bin/sh -c ./run_dispatche ...   Up
bonde-install_redis_1                     docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
```

## What's next?

Go to the local admin v1 url: http://app.bonde.devel.

When login form finish to load, use "admin_foo@bar.com" as e-mail and "foobar!!" as password. After login, you will must create a community and mobilization.

To more detailed documentation about technical decisions, or how to contribute, access http://docs.bonde.org or run ```make docs```.


