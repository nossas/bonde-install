# Bonde Infra

## Requirements

Our development enviroment can be setup in two different ways, using vagrant or with local docker.

If you only want to start containers locally:

- Docker ( required 17.10.0-ce or later ) - https://docs.docker.com/install/
- Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
- Make ( optional: 3.81 ) - https://www.gnu.org/software/make/

  - If you don't have `make` installed, just run:

    ```bash
      sudo apt-get update
      sudo apt-get install build-essentials
    ```

To provision services using VirtualBox and Vagrant, we recomend the following versions:

- VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
- Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html

It's not recommended to have any other programs running in network ports, considering the possible conflict errors with BONDE's apps.

If there's any error related to ports already in use, check your computer's port status via command line:

```bash
sudo lsof -i -P -n | grep LISTEN
```

On that note, it's also good to reinforce that all of BONDE's apps run via docker-compose files. They setup all the infrastructure for the backend/database to run, so you don't have to worry about configurations for postegres, pgAdmi4, server, etc, _it does it all for you_.

On windows, we recommend that you use virtual box and vagrant.

**Important**: In case of problems when running make begin run `make clean` and try again

If you want to test mail, s3 and elasticsearch integrations used by our modules, you should run:

`sudo sysctl -w vm.max_map_count=262144` to enable elastic watch more files than default set in kernel.

## Access Third-party services

Add to `/etc/hosts` the following line:

```
127.0.0.1 admin-canary.bonde.devel app.bonde.devel redes.bonde.devel accounts.bonde.devel traefik.bonde.devel s3.bonde.devel smtp.bonde.devel pgadmin.bonde.devel kibana.bonde.devel api-rest.bonde.devel api-graphql-deprecated.bonde.devel api-graphql.bonde.devel api-payments.bonde.devel api-domains.bonde.devel api-activists.bonde.devel api-redes.bonde.devel api-accounts.bonde.devel api-notifications.bonde.devel teste-de-widgets.bonde.devel api-v2.bonde.devel
```

And `make extras` to load services to be used at:

- http://s3.bonde.devel
- http://smtp.bonde.devel
- http://traefik.bonde.devel
- http://pgadmin.bonde.devel
- http://kibana.bonde.devel

## Configure First Access

Go to the client admin url: http://app.bonde.devel

When the login form finishes loading, you'll still need to follow some steps to create your own local access to the admin panel.

1. Access **api-graphql.bonde.devel** and import basic data

- Click on the settings icon that's located at the right corner of the screen
- Click on the button _Import metadata_

3. Restart the api-graphql container

- On terminal, run: `docker-compose restart api-graphql`

4. Reload the **api-graphql.bonde.devel** page:

- Create a new Communities on console:

```
mutation InsertCommunity {
  insert_communities (objects: {
    name: "Minha Organização",
    city: "Rio de Janeiro",
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

- Register a new Users on console

```
mutation MyMutation2 {
  insert_invitations(objects: {email: "foo@bar.com", code:"111111", role:"1", expired:false, community_id: 1}){
    affected_rows
  }
}

mutation MyMutation3 {
  register(input: {code: "111111", email: "foo@bar.com", first_name: "FOO", password: "123456"}) {
    valid
  }
}
```

- Create relationship CommunityUsers on console

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

And last but not least, we must rebuild client and api with the following command:

`make clients-rebuild && make apis-rebuild`

If it all went well, go back to **admin-canary.bonde.devel** where you now have a login. Use "admin_foo@bar.com" as e-mail and "foobar!!" as password. After login, you can create mobilizations or play around with all the other features the app offers.

To more detailed documentation about technical decisions, or how to contribute, access http://docs.bonde.org or run `make docs`.

## Database

### How to Access

If you check the "docker-compose.commom.yml", there are two setups that configure the database: pgmaster and pgadmin4. To run the database visualization (pgAdmin4), do the following:

- Run the pgAdmin4 enviroment
  `docker-compose -f docker-compose.common.yml up -d pgadmin4`
- Check to see if it went well
  `docker-compose -f docker-compose.common.yml logs -f pgadmin4`
- Then, access the database via (setup by traefik) **pgadmin.bonde.devel**
- When the page loads, access the database with e-mail and login provided by the docker-compose _common_ file, then, go to pgadmin4 and you'll find the credentials
- When it loads, click in **Add new server**
- Give any name you'd like to the server (general tab)
- Now go to the **Connection** tab
  - host name/address: pgmaster
  - port: _default port_
  - maintance database: bonde
  - username: monkey_user
  - password: monkey_pass
- Hit **save** and you're ready to go!

### How to Modify

Commands to create new migrations are related to hasura-cli and we recommend use `hasura console` to generate new migrations

### How to Seed from sql files

Copy sql file to `backups/` folder, before start.

```
docker-compose exec pgmaster sh
# psql -hlocalhost -Umonkey_user -W bonde < /backups/local.txt
```

## Check Services Health

Congratulations, when command finished of running, you could check if everything are ok running `make status`, you should see a table like the following:
