FROM php:8.3-fpm-alpine

RUN apk --update --no-cache add  \
		linux-headers \
		git \
		autoconf \
		g++ \
		make && \
    pecl install -f xdebug && \
    docker-php-ext-install opcache && \
    docker-php-ext-install pdo_mysql  && \
    docker-php-ext-enable xdebug  && \
    #FIXME: 777 shouldn't be required, only xdebug needs to write to xdebug.log
    touch /tmp/xdebug.log && chmod 777 /tmp/xdebug.log

RUN apk --no-cache add \
    libzip-dev \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && apk del libzip-dev

RUN apk --no-cache add \
    icu-libs \
    icu-dev \
    && docker-php-ext-install intl

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www
CMD ["php-fpm"]
EXPOSE 9000
