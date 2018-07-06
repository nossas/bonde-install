CURRENT_DIRECTORY := $(shell pwd)

TESTSCOPE = apps
TESTFLAGS = --with-timer --timer-top-n 10 --keepdb

help:
	@echo "Docker Compose Help"
	@echo "-----------------------"
	@echo ""
	@echo "Run cleaner task to ensure current state is good:"
	@echo "    make clean"
	@echo ""
	@echo "After cleaning, add fixture data and start up database:
	@echo "    make migrate"
	@echo ""
	@echo "Start common services: load balancer, consul, s3, smtp:"
	@echo "    make begin"
	@echo ""
	@echo "See contents of Makefile for more targets."

begin: start rebuild

start:
	@docker-compose up -d storeconfig consul traefik admin public
	@docker-compose restart traefik
	@docker-compose -f docker-compose.dispatchers.yml up -d

stop:
	@docker-compose stop
	@docker-compose -f docker-compose.workers.yml stop
	@docker-compose -f docker-compose.dispatchers.yml stop

status:
	@docker-compose ps
	@docker-compose -f docker-compose.workers.yml ps
	@docker-compose -f docker-compose.dispatchers.yml ps

restart: stop start

clean: stop
	@docker-compose rm -f docker-compose.workers.yml --force
	@docker-compose rm -f docker-compose.dispatchers.yml --force
	@docker-compose rm --force
	@docker-compose down -f docker-compose.workers.yml -v --remove-orphans
	@docker-compose down -f docker-compose.dispatchers.yml -v --remove-orphans
	@docker-compose down -v --remove-orphans

rebuild:
	@docker-compose exec -T admin npm run buildx
	@docker-compose exec -T public npm run build

migrate:
	@docker-compose up -d pgmaster pgpool
	@sleep 5;
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database concourse"
	@docker-compose -f docker-compose.workers.yml up -d migrations
	@sleep 20;
	@docker-compose -f docker-compose.workers.yml up -d seeds

dispatchers:
	# @docker-compose -f docker-compose.dispatchers.yml exec -e FN_REGISTRY=nossas -e FN_API_URL=fn.bonde.devel -T dispatcher-notification fn apps create domain
	# @fn apps config s domain DATABASE_URL postgres://monkey_user:monkey_pass@pgpool:5432/bonde
	# @fn apps config s domain AWS_REGION aws_region
	# @fn apps config s domain AWS_ACCESS_KEY_ID aws_access_key_id
	# @fn apps config s domain AWS_SECRET_ACCESS_KEY aws_secret_access_key
	# @fn apps config s domain AWS_ROUTE_IP aws_route_ip
	# @fn apps config s domain JWT_SECRET jwt_secret_key
	# @fn deploy --app domain --local

logs:
	@docker-compose logs -f

start-logger:
	@docker-compose -f docker-compose.monitor.yml up -d logspout kibana

start-monitor:
	@docker-compose -f docker-compose.monitor.yml up -d scope

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean migrate dispatchers serverless logs start-logger start-monitor tail
