# # Stick with php7.4
FROM php:7.4-apache
RUN apt-get update

# Get latest Composer
RUN apt-get install -y git zip unzip vim
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql exif pcntl bcmath
RUN a2enmod rewrite

WORKDIR /redis
RUN apt-get install -y redis \
    && redis-server --daemonize yes

COPY . /var/www
WORKDIR /var/www
RUN composer install
# RUN php artisan key:generate
RUN php artisan migrate --force
RUN php artisan queue:work redis &
COPY public /var/www/html

EXPOSE 80