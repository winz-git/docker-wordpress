FROM php:7.4-fpm-alpine

LABEL version=1.0.2 author="Winston Castillo" author.email=winz.git@gmail.com

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
    php7-common \
    php7-mbstring \
    php7-sodium \
    php7-intl \
    php7-xml \
    php7-mcrypt \
    php7-imagick \
    php7-pcntl \
    php7-zip

# gd
RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd     

# add pdo_mysql or mysqli
## for Fatal error: Uncaught Error: Call to undefined function mysql_connect()
RUN docker-php-ext-install bcmath \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    pcntl \
    sockets \
    zip

# enable enable which myql library to use
RUN docker-php-ext-enable pdo_mysql 

# enable imagick
RUN printf "\n" | pecl install \
		imagick && \
		docker-php-ext-enable --ini-name 20-imagick.ini imagick


# install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar\
 && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp


# Download using curl
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
 && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar

RUN chmod +x php*.phar

RUN mv phpcbf.phar /usr/local/bin/phpcbf
RUN mv phpcs.phar /usr/local/bin/phpcs

# install codesniffer
RUN pear install PHP_CodeSniffer && \
    mkdir /usr/local/lib/php/PHP/CodeSniffer/Standards

# WordPress Standards
RUN mkdir /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards && \
    curl -L https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards/tarball/master > /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards/WordPress-Coding-Standards.tar.gz && \
    tar -xvzf /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards/WordPress-Coding-Standards.tar.gz -C /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards --strip-components=1 && \
    rm /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards/WordPress-Coding-Standards.tar.gz

# CodeSniffer configuration
RUN phpcs --config-set severity 1 && \
    phpcs --config-set colors 1 && \
    phpcs --config-set show_progress 1 && \
    phpcs --config-set default_standard PSR2 && \
    phpcs --config-set installed_paths /usr/local/lib/php/PHP/CodeSniffer/Standards/WordPress-Coding-Standards


COPY ./config/php.ini /usr/local/etc/php

WORKDIR /var/www/html


EXPOSE 9000

CMD ["php-fpm"]
