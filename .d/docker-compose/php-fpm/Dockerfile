FROM php:8.1.0alpha1-fpm

ENV COMPOSER_HOME=/usr/local/composer \
    PATH=/usr/local/composer/vendor/bin:$PATH

ARG env

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && \
    apt-get -y --no-install-recommends install \
        librabbitmq-dev libimage-exiftool-perl libzip-dev zip curl wget git \
        unzip p7zip-full openssl sendmail apt-transport-https aptitude apt-utils \
        libmcrypt-dev vim tree htop \
#
        g++ make gcc rar ssh
#
        php php-dev php-cli php-fpm php-common php-json php-pdo php-mysql \
        php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath \
        php-intl php-interbase php-readline php-opcache php-xml php-xmlrpc \
# php-codesniffer
&& phpModules=" \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        mysqli \
#        opcache \
        pdo_mysql \
        pgsql \
        pspell \
        shmop \
        snmp \
        soap \
        sockets \
        tidy \
        xsl \
        zip \
    " \

    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
#    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
#    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) $phpModules \
    && pecl install xdebug\
    && pecl install memcached \
    && pecl install amqp \
    && pecl install mongodb \
    && docker-php-ext-enable amqp zip mysqli pdo pdo_mysql opcache xdebug \

# REDIS
RUN pecl install -o -f redis \
  &&  rm -rf /tmp/pear \
  &&  docker-php-ext-enable redis \

# COMPOSER
#    && curl -sS https://getcomposer.org/installer | php --\
#        --filename=composer \
#    && mv composer.phar /usr/local/bin/composer \
#    && chmod 755 /usr/local/bin/composer \
#    && chown www-data:www-data $COMPOSER_HOME \
#    && chown www-data:www-data $COMPOSER_HOME -R \
#    && chmod 775 $COMPOSER_HOME \
#    && chmod 775 $COMPOSER_HOME -R \

# COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer \
        --install-dir=/usr/local/bin \
    && chmod 755 /usr/local/bin \
    && chmod 755 /usr/local/bin/composer \
    && chown www-data:www-data $COMPOSER_HOME \
    && chown www-data:www-data $COMPOSER_HOME -R \
    && chmod 775 $COMPOSER_HOME \
    && chmod 775 $COMPOSER_HOME -R \
    && echo "alias composer='COMPOSER_MEMORY_LIMIT=-1 composer'" >> /root/.bashrc \
    && composer \

RUN echo "sendmail_path=/usr/sbin/sendmail -t -i" >> /usr/local/etc/php/conf.d/sendmail.ini
RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint
RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

COPY www.conf /usr/local/etc/php-fpm.d
COPY ${env}/opcache.ini "$PHP_INI_DIR"/conf.d
COPY ${env}/xdebug.ini "$PHP_INI_DIR"/conf.d
COPY ${env}/php.ini "$PHP_INI_DIR"/conf.d

WORKDIR "/application"

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*