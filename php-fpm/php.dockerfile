FROM php:7.2-fpm-alpine

# override default php-fpm www.conf with our local version
# to fetch the default www.conf from the container run
# docker run --rm php:7.4-fpm-alpine cat /usr/local/etc/php-fpm.d/www.conf > www.conf
ADD ./www.conf /usr/local/etc/php-fpm.d/www.conf

# override default php.ini with our local version
# to fetch the default php.ini-development or php.ini-production
# from the container run
# docker run --rm php:7.4-fpm-alpine cat /usr/local/etc/php/php.ini-development > php.ini-development
ADD ./php.ini-development /usr/local/etc/php/php.ini

# laravel lists the following extensions for its dependency
# bcmath, ctype, fileinfo, json, mbstring, openssl, pdo,
# tokenizer and xml
# the image we're using only needs bcmath and pdo_mysql to be
# installed since other extensions are present
# you can verify the installed extensions beforehand using
# docker run -it --rm php:7.4-fpm-alpine php -m
RUN apk add --no-cache freetds \
    freetds-dev \
    && docker-php-ext-install bcmath \
    pdo_mysql \
    pdo_dblib

# create the /var/www/html directory, -p for creating the parent
# directories if they're not present
# change the owner of the directory to www-data
RUN mkdir -p /var/www/html && chown www-data:www-data /var/www/html
