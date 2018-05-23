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
	@docker-compose up -d storeconfig consul traefik admin public
	@docker-compose exec -T admin npm run buildx
	@docker-compose exec -T public npm run build
	@docker-compose restart traefik

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
	@docker-compose -f docker-compose.workers.yml up -d migrations
	@sleep 20;
	@docker-compose -f docker-compose. up -d seeds

dispatchers:
	@export FN_REGISTRY=nossas
	@export FN_API_URL=fn.bonde.devel
	@fn apps config s YOUR_APP DATABASE_URL postgres://monkey_user:monkey_pass@pgpool:5432/bonde
	@fn apps config s YOUR_APP AWS_REGION aws_region
	@fn apps config s YOUR_APP AWS_ACCESS_KEY_ID aws_access_key_id
	@fn apps config s YOUR_APP AWS_SECRET_ACCESS_KEY aws_secret_access_key
	@fn apps config s YOUR_APP AWS_ROUTE_IP aws_route_ip
	@fn apps config s YOUR_APP JWT_SECRET jwt_secret_key
	@fn deploy --app YOUR_APP --local

serverless:
	@docker-compose -f docker-compose.dispatchers.yml up -d

logs:
	@docker-compose logs -f

start-logger:
	@docker-compose -f docker-compose.monitor.yml up -d logspout kibana

start-monitor:
	@docker-compose -f docker-compose.monitor.yml up -d scope

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean migrate dispatchers serverless logs start-logger start-monitor tail
