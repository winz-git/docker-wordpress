FROM php:7.4-fpm-alpine

LABEL version=1.0.0 author="Winston Castillo" author.email=winz.git@gmail.com

# add extra tools
# freetype, libjpeg libpng libzip required by gd
RUN apk add --update --no-cache \
    $PHPIZE_DEPS \
    bash \
    vim \
    git \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    imagemagick \
	imagemagick-libs \
	imagemagick-dev \
	php7-imagick \
	php7-pcntl 

# gd
RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd     

# add pdo_mysql or mysqli
## for Fatal error: Uncaught Error: Call to undefined function mysql_connect()
RUN docker-php-ext-install mysqli pdo pdo_mysql

# enable enable which myql library to use
RUN docker-php-ext-enable mysqli pdo_mysql 

# enable imagick
RUN printf "\n" | pecl install \
		imagick && \
		docker-php-ext-enable --ini-name 20-imagick.ini imagick


# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar\
 && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./config/php.ini /usr/local/etc/php

WORKDIR /var/www/html


EXPOSE 9000

CMD ["php-fpm"]