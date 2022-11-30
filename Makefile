CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

build:
	docker-compose build

start:
	@if ! [ -d ./chains/data/consumer ]; \
		then mkdir ./chains/data/consumer ; \
	fi
	@if ! [ -d ./chains/data/hermes ]; \
		then mkdir ./chains/data/hermes ; \
	fi
	env UID=${CURRENT_UID} GID=${CURRENT_GID} docker-compose up

silent:
	docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose stop
	rm -rf ./chains/data/consumer || true

delete:
	docker-compose stop
	rm -rf ./chains/data/consumer || true
	docker-compose down --rmi all -v --remove-orphans