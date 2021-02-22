# # Stick with php7.4
FROM php:7.4-apache
RUN apt-get update

# Get latest Composer
RUN apt-get install -y git zip unzip vim redis supervisor cron
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql exif pcntl bcmath \
    && docker-php-ext-enable pdo_pgsql
RUN a2enmod rewrite

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
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Cron Job 
COPY docker/laravel-cron /etc/cron.d/laravel-cron
RUN chmod 0644 /etc/cron.d/laravel-cron

# Preparation
# RUN php artisan key:generate  # not required env set already.
RUN php artisan migrate --force
EXPOSE 80
COPY docker/start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]