build: common up ps composer

up:
	docker-compose \
	    -f .docker-data/docker-compose/docker-compose.yml \
	    -f .docker-data/docker-compose/docker-compose.dev.yml \
	    -f .docker-data/docker-compose/docker-compose.cli.yml \
	    up -d --build

prod:
	crontab -r
	docker-compose \
	    -f .docker-data/docker-compose/docker-compose.yml \
	    -f .docker-data/docker-compose/docker-compose.prod.web.yml \
	    -f .docker-data/docker-compose/docker-compose.cli.yml \
	    up -d --build
	docker exec -t php-fpm bash -c 'COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader'
	cat .docker-data/docker-compose/crontab | crontab -

common:
	docker-compose -f .docker-data/docker-compose/docker-compose.common.yml up -d --build

down:
	docker-compose -f .docker-data/docker-compose/docker-compose.yml -f .docker-data/docker-compose/docker-compose.dev.yml stop

ps:
	docker-compose -f .docker-data/docker-compose/docker-compose.yml -f .docker-data/docker-compose/docker-compose.dev.yml ps

composer:
	docker exec -t php-fpm bash -c 'COMPOSER_MEMORY_LIMIT=-1 composer install'

worker-log:
	docker-compose -f .docker-data/docker-compose/docker-compose.cli.yml logs -f async_consumer
