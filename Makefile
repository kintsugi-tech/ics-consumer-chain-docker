CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

build:
	docker-compose build

start:
	# mkdir ./chains/data/consumer
	env UID=${CURRENT_UID} GID=${CURRENT_GID} docker-compose up

silent:
	env UID=${CURRENT_UID} GID=${CURRENT_GID} docker-compose up -d

stop:
	docker-compose stop

reset:
	docker-compose stop
	rm -rf ./chains/data/consumer || true

delete:
	docker-compose stop
	rm -rf ./chains/data/consumer || true
	docker-compose down --rmi all -v --remove-orphans