FROM php:7.4-fpm-alpine

# add extra tools
RUN apk add --no-cache \
    bash \
    vim

# add pdo_mysql or mysqli
## for Fatal error: Uncaught Error: Call to undefined function mysql_connect()
RUN docker-php-ext-install mysqli pdo pdo_mysql

# enable
RUN docker-php-ext-enable mysqli pdo_mysql 

# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar\
 && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./config/php.ini /usr/local/etc/php

WORKDIR /var/www/html


EXPOSE 9000

CMD ["php-fpm"]