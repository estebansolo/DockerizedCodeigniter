FROM php:7.2.26-apache

COPY www/ /var/www/html
COPY ci/site.conf /etc/apache2/sites-available/site.conf

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends --fix-missing -y libpq-dev \
    zip \
    unzip \
    git \
    nano \
    libxml2-dev \
    libbz2-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libsqlite3-0 \
    curl

RUN docker-php-ext-install intl

# Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN cd /var/www/html && composer update
RUN apt-get clean && rm -r /var/lib/apt/lists/*


RUN a2dissite 000-default.conf
RUN a2ensite site.conf
RUN a2enmod rewrite

RUN chmod -R 0777 /var/www/html/writable