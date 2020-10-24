# # Stick with php7.4
FROM php:7.4-apache
RUN apt-get update

# Get latest Composer
RUN apt-get install -y git zip unzip vim
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql exif pcntl bcmath
RUN a2enmod rewrite

# Install redis
WORKDIR /redis
RUN apt-get install -y redis \
    && redis-server --daemonize yes

# Install redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Web
COPY . /var/www
COPY public /var/www/html
WORKDIR /var/www
RUN composer install

# Change ownership
RUN chown -R www-data:www-data /var/www

# Supervisor
COPY docker/envault-log /envault-log
RUN apt-get install -y supervisor 
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Preparation
# RUN php artisan key:generate  # not required env set already.
RUN php artisan migrate --force
EXPOSE 80
COPY docker/start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]