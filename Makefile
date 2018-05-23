CURRENT_DIRECTORY := $(shell pwd)

TESTSCOPE = apps
TESTFLAGS = --with-timer --timer-top-n 10 --keepdb

help:
	@echo "Docker Compose Help"
	@echo "-----------------------"
	@echo ""
	@echo "Run tests to ensure current state is good:"
	@echo "    make test"
	@echo ""
	@echo "If tests pass, add fixture data and start up the api:"
	@echo "    make begin"
	@echo ""
	@echo "Really, really start over:"
	@echo "    make clean"
	@echo ""
	@echo "See contents of Makefile for more targets."

start:
	@docker-compose up -d storeconfig traefik01 admin public
	@docker-compose exec -T admin npm run build
	@docker-compose restart traefik01

stop:
	@docker-compose stop

status:
	@docker-compose ps

restart: stop start

clean: stop
	@docker-compose rm --force
	@docker-compose down -v --remove-orphans

migrate:
	@docker-compose up -d pgpool
	@sleep 5;
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database concourse"
	@docker-compose up -d migrations
	@sleep 20;
	@docker-compose up -d seeds

dispatchers:
	@docker-compose up -d dispatcher-domains
	@git clone git@github.com:nossas/domain-service.git
	@cd domain-service
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP DATABASE_URL postgres://connection_string
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP AWS_REGION aws_region
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP AWS_ACCESS_KEY_ID aws_access_key_id
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP AWS_SECRET_ACCESS_KEY aws_secret_access_key
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP AWS_ROUTE_IP aws_route_ip
	@FN_API_URL=fnserver:8080 fn apps config s YOUR_APP JWT_SECRET jwt_secret_key
	@FN_API_URL=fnserver:8080 fn deploy --app YOUR_APP --local

extras: manage-logs monitor serverless

logs:
	@docker-compose logs -f

data:
	@docker-compose up -d metabase redash

manage-logs:
	@docker-compose up -d logspout kibana

monitor:
	@docker-compose up -d scope

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean serverless log monitor tail
