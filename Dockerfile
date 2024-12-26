# Use an official PHP runtime with Alpine for a lightweight image
FROM php:8.2-fpm-alpine3.18 AS base

# Set working directory
WORKDIR /var/www/html/todo-app

# Install system dependencies, PHP extensions, Node.js, Nginx, and supervisor
RUN apk --no-cache add \
    git \
    curl \
    wget \
    libzip-dev \
    nginx \
    supervisor \
    nodejs \
    npm \
    build-base \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    mysql-client \
    zlib-dev \
    libxml2-dev \
    linux-headers \
    autoconf

# Install PHP extensions
RUN docker-php-ext-install \
        pdo_mysql \
        gd \
        xml \
        zip \
        opcache \
        sockets \
    && pecl install excimer \
    && docker-php-ext-enable excimer \
    && rm -rf /var/cache/apk/*

# Copy PHP and Nginx configurations
COPY docker/php/php.ini /usr/local/etc/php/php.ini
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

# Set PHP to production mode
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add a non-root user for application security
RUN addgroup -S laravel && adduser -S laravel -G laravel

# Set up Composer (using the official Composer image)
COPY --from=composer:2.6.5 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . /var/www/html

# Install PHP dependencies (Composer)
RUN composer install --no-interaction --optimize-autoloader --prefer-dist --no-progress --no-suggest \
    && rm -rf /var/www/html/.env.example

# Final lightweight image for production
FROM base AS production

# Set environment variables for production
ENV APP_ENV=production
ENV APP_DEBUG=false

# Switch to root user to set permissions
USER root

# Set proper permissions for storage, cache, and log directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && find /var/www/html/storage/logs/ -type f -name "*.log" -exec chmod 775 {} \; \
    && find /var/www/html/storage/logs/ -type f -name "*.log" -exec chown www-data:www-data {} \;

# Expose port 80 for Nginx
EXPOSE 80

# Command to run supervisord (manages Nginx & PHP-FPM)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
