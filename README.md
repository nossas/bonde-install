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

Our development enviroment can be setup in two different ways, using vagrant or with local docker.

If you only want to start containers locally:

* Docker ( required 17.10.0-ce or later ) - https://docs.docker.com/install/
* Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
* Make ( optional: 3.81 ) - https://www.gnu.org/software/make/
  * If you don't have `make` installed, just run:

    ``` bash
      sudo apt-get update
      sudo apt-get install build-essentials
    ```

To provision services using VirtualBox and Vagrant, we recomend the following versions:

* VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html

It's not recommended to have any other programs running in network ports, considering the possible conflict errors with BONDE's apps.

If there's any error related to ports already in use, check your computer's port status via command line:

``` bash
sudo lsof -i -P -n | grep LISTEN
```

On that note, it's also good to reinforce that all of BONDE's apps run via docker-compose files. They setup all the infrastructure for the backend/database to run, so you don't have to worry about configurations for postegres, pgAdmi4, server, etc, *it does it all for you*.

## How to

When running the commands they'll be downloading a big amount of gigabytes, and some commands will demand  high levels of usage from CPU:

``` bash
mkdir bonde
cd bonde
git clone git@github.com:nossas/bonde-install.git
cd bonde-install
make begin
```

**Important**: In case of problems when running make begin run `make clean` and try again

Add to ```/etc/hosts``` following lines:

``` bash

127.0.0.1 traefik.bonde.devel api-rest.bonde.devel api-graphql.bonde.devel api-v2.bonde.devel db.devel keyval.devel graphql-auth.bonde.devel

127.0.0.1 pgadmin.bonde.devel fake-smtp.bonde.devel

127.0.0.1 bonde.devel app.bonde.devel admin-canary.bonde.devel cross-storage.bonde.devel chatbot.bonde.devel

127.0.0.1 3-vamos-limpar-o-tiete.bonde.devel 2-save-the-whales.bonde.devel 1-vamos-limpar-o-tiete.bonde.devel

```

These are essentials URLs from BONDE and must be accessible to get local copy fully working:

* api-v1.bonde.devel
* api-v2.bonde.devel
* app.bonde.devel
* pgadmin.bonde.devel
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

### Migrations

Commands to create new:

``docker-compose run --rm migrations diesel migration generate initial_chatbot``

### Dispatchers

#### Notifications

Check if templates and jwt_secret are added to database after migrations synced.

To Run:

```docker-compose up -d notifications```

### Database

If you check the "docker-compose.commom.yml", there are two setups that configure the database: pgmaster and pgadmin4. To run the database visualization (pgAdmin4), do the following:

* Run the pgAdmin4 enviroment
  `docker-compose -f docker-compose.common.yml up -d pgadmin4`
* Check to see if it went well
  `docker-compose -f docker-compose.common.yml logs -f pgadmin4`
* Then, access the database via (setup by traefik) **pgadmin.bonde.devel**
* When the page loads, access the database with e-mail and login provided by the docker-compose *common* file, then, go to pgadmin4 and you'll find the credentials
* When it loads, click in **Add new server**
* Give any name you'd like to the server (general tab)
* Now go to the **Connection** tab
  * host name/address: pgmaster
  * port: *default port*
  * maintance database: bonde
  * username: monkey_user
  * password: monkey_pass
* Hit **save** and you're ready to go!

## Check

Congratulations, when command finished of running, you could check if everything are ok running ```make status```, you should see a table like the following:

``` bash
                  Name                                 Command               State                                 Ports
------------------------------------------------------------------------------------------------------------------------------------------------------
bonde-install_api-graphql_1                 graphql-engine serve             Up       0.0.0.0:5007->8080/tcp
bonde-install_api-rest_1                    bundle exec puma -C config ...   Up       3000/tcp
bonde-install_api-v2_1                      npm run dev                      Up       0.0.0.0:3002->3002/tcp
bonde-install_chatbot_1                     docker-entrypoint.sh yarn  ...   Up
bonde-install_graphql-auth_1                docker-entrypoint.sh /bin/ ...   Up
bonde-install_migrations_1                  diesel migration run             Exit 0
bonde-install_pgmaster_1                    docker-entrypoint.sh postgres    Up       0.0.0.0:32770->5432/tcp
bonde-install_redis_1                       docker-entrypoint.sh redis ...   Up       0.0.0.0:6379->6379/tcp
bonde-install_s3_1                          /usr/bin/docker-entrypoint ...   Up       0.0.0.0:9000->9000/tcp
bonde-install_smtp_1                        MailHog                          Up       0.0.0.0:1025->1025/tcp, 0.0.0.0:8025->8025/tcp
bonde-install_traefik_1                     /entrypoint.sh --configfil ...   Up       0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:8080->8080/tcp
bonde-install_webhook-activists_1           docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhook-mail_1                docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-registry_1           docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-solidarity-count_1   docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-solidarity-match_1   docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-zendesk_1            docker-entrypoint.sh /bin/ ...   Up
            Name                           Command               State          Ports
---------------------------------------------------------------------------------------------
bonde-install_cross-storage_1   /bin/bash -c exec nginx -g ...   Up      0.0.0.0:8888->80/tcp
Name   Command   State   Ports
------------------------------
Name   Command   State   Ports
------------------------------
Name   Command   State   Ports
------------------------------
                  Name                                 Command               State   Ports
------------------------------------------------------------------------------------------
bonde-install_chatbot_1                     docker-entrypoint.sh yarn  ...   Up
bonde-install_graphql-auth_1                docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhook-activists_1           docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhook-mail_1                docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-registry_1           docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-solidarity-count_1   docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-solidarity-match_1   docker-entrypoint.sh /bin/ ...   Up
bonde-install_webhooks-zendesk_1            docker-entrypoint.sh /bin/ ...   Up
             Name                            Command               State     Ports
------------------------------------------------------------------------------------
bonde-install_api-rest_1          bundle exec puma -C config ...   Up       3000/tcp
bonde-install_migrations_1        diesel migration run             Exit 0
bonde-install_templates-email_1   bundle exec rake notificat ...   Exit 0
          Name                        Command               State                                Ports
------------------------------------------------------------------------------------------------------------------------------------
bonde-install_pgadmin4_1   /entrypoint.sh                   Up      443/tcp, 0.0.0.0:5433->80/tcp
bonde-install_pgmaster_1   docker-entrypoint.sh postgres    Up      0.0.0.0:32770->5432/tcp
bonde-install_redis_1      docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
bonde-install_s3_1         /usr/bin/docker-entrypoint ...   Up      0.0.0.0:9000->9000/tcp
bonde-install_smtp_1       MailHog                          Up      0.0.0.0:1025->1025/tcp, 0.0.0.0:8025->8025/tcp
bonde-install_traefik_1    /entrypoint.sh --configfil ...   Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:8080->8080/tcp

```

## What's next

Go to the local admin v2 url: http://admin-canary.bonde.devel (follow README instructions from the repo to get it running)

When the login form finishes loading, you'll still need to follow some steps to create your own local access to the admin panel.

1. Access **api-graphql.bonde.devel** and import metadata

* Click on the settings icon that's located at the right corner of the screen
* Click on the button *Import metadata*
* Select the file **metadata.json** that's located in this repo

2. Access the database (http://pgadmin.bonde.devel/) and insert `public.configurations`  in database with `JWT_SECRET` environment on graphql-auth service:

* Click on [database name] > Databases > bonde
* Click on the Dropdown item in the menu called *Tools*, then, *Query tool*
* Paste this code in the *Query Editor*

``` sql
  -- USED TO CRYPTO RGISTER AND AUTHENTICATE GRAPHQL
  insert into configurations(name, value, created_at, updated_at) values('jwt_secret', 'segredo123', now(), now());

  -- USED TO TAGGED USER WHEN OPEN http://admin-canary.bonde.devel:5002
  insert into tags ("name", "label") values ('user_meio-ambiente', 'Meio Ambiente'), ('user_direitos-humanos', 'Direitos Humanos'),
  ('user_segurança-publica', 'Segurança pública'), ('user_mobilidade', 'Mobilidade'), ('user_direito-das-mulheres', 'Direito das Mulheres'),
  ('user_feminismo', 'Feminismo'), ('user_participacao-social', 'Participação Social'), ('user_educacao', 'Educação'),
  ('user_transparencia', 'Transparência'), ('user_direito-lgbtqi+', 'Direito LGBTQI+'), ('user_direito-a-moradia', 'Direito à Moradia'),
  ('user_combate-a-corrupção', 'Combate à Corrupção'), ('user_combate-ao-racismo', 'Combate ao Racismo'), ('user_saude-publica', 'Saúde Pública');
```

3. Restart the api-graphql container
  * On terminal, run: `docker-compose restart api-graphql`

4. Reload the **api-graphql.bonde.devel** page:

* Register a new Users on console

```
mutation RegisterUser {
  register (input: {
    data: "{\"email\": \"admin_foo@bar.com\", \"password\": \"foobar!!\", \"first_name\": \"Foo!\"}"
  }) {
    jwtToken
  }
}
```

* Create a new Communities on console:

```
mutation InsertCommunity {
  insert_communities (objects: {
    name: "Beta",
    city: "Brasil",
    created_at: "2019-09-03 00:00:00",
    updated_at: "2019-09-03 00:00:00"
  }) {
    returning {
      id
      name
      city
      modules
      created_at
    }
  }
}
```

* Create relationship CommunityUsers on console

```
mutation InsertCommunityUsers {
  insert_community_users(objects: {
  	# ID RETURNING OF INSERT COMMUNITY
    community_id: 1,
    # ID RETURNING OF QUERY currentUser
    user_id: 1,
    # ROLE ON COMMUNITY CONTEXT DEFAULT ADMIN
    role: 1,
    created_at: "2019-09-03 00:00:00",
    updated_at: "2019-09-03 00:00:00"
  }) {
    returning {
      id
      community_id
      user_id
      role
    }
  }
}
```

If it all went well, go back to **admin-canary.bonde.devel** where you now have a login. Use "admin_foo@bar.com" as e-mail and "foobar!!" as password. After login, you can create mobilizations or play around with all the other features the app offers.

To more detailed documentation about technical decisions, or how to contribute, access http://docs.bonde.org or run ```make docs```.


## Seeds from sql files

Copy sql file to ```backups/``` folder, before start.

```
docker-compose exec pgmaster sh
# psql -hlocalhost -Umonkey_user -W bonde < /backups/local.txt
 ```