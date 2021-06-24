FROM php:8.1.0alpha1-cli

ENV COMPOSER_HOME=/usr/local/composer \
    PATH=/usr/local/composer/vendor/bin:$PATH

# Use the default development php.ini configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && apt-get -y --no-install-recommends install \
#
    openssl cron locales librabbitmq-dev libimage-exiftool-perl \
    libzip-dev zip unzip p7zip-full sendmail bzip2 wget tar \
#
    && pecl install xdebug \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install zip mysqli pdo pdo_mysql opcache

# REDIS
RUN pecl install -o -f redis \
  &&  rm -rf /tmp/pear \
  &&  docker-php-ext-enable redis

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin && \
        echo "alias composer='COMPOSER_MEMORY_LIMIT=-1 composer'" >> /root/.bashrc && \
        composer

# LOCALE
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN echo "sendmail_path=/usr/sbin/sendmail -t -i" >> /usr/local/etc/php/conf.d/sendmail.ini
RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint
RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

COPY php.ini "$PHP_INI_DIR"/conf.d

WORKDIR "/application"

CMD cron -f