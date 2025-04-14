FROM php:8.3-apache

WORKDIR /

RUN apt update

RUN apt install wget unzip -y \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/f3108f64b4e1c1ce6eb462b159956461592b3e3e/web/installer -O - -q | php -- --quiet

RUN mv composer.phar /usr/local/bin/composer

RUN composer create-project drupal/cms
