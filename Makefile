build: common up ps composer

up:
	docker-compose \
	    -f .d/docker-compose/docker-compose.yml \
	    -f .d/docker-compose/docker-compose.dev.yml \
	    -f .d/docker-compose/docker-compose.cli.yml \
	    up -d --build

prod:
	crontab -r
	docker-compose \
	    -f .d/docker-compose/docker-compose.yml \
	    -f .d/docker-compose/docker-compose.prod.web.yml \
	    -f .d/docker-compose/docker-compose.cli.yml \
	    up -d --build
	docker exec -t php-fpm bash -c 'COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader'
	cat .d/docker-compose/crontab | crontab -

common:
	docker-compose -f .d/docker-compose/docker-compose.common.yml up -d --build

down:
	docker-compose -f .d/docker-compose/docker-compose.yml -f .d/docker-compose/docker-compose.dev.yml stop

ps:
	docker-compose -f .d/docker-compose/docker-compose.yml -f .d/docker-compose/docker-compose.dev.yml ps

composer:
	docker exec -t php-fpm bash -c 'COMPOSER_MEMORY_LIMIT=-1 composer install'
