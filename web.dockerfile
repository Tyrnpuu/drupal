FROM php:8.3-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/drupal/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /

RUN apt update

RUN apt install wget unzip -y \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli pdo pdo_mysql

RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/f3108f64b4e1c1ce6eb462b159956461592b3e3e/web/installer -O - -q | php -- --quiet

RUN mv composer.phar /usr/local/bin/composer

RUN cd /var/www/html

RUN composer create-project drupal/cms /var/www/html/drupal

COPY settings.php /var/www/html/drupal/web/sites/default/settings.php

RUN chown -R www-data:www-data /var/www/html/drupal
RUN chmod -R 755 /var/www/html/drupal