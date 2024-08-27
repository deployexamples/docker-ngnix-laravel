FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    zip \
    pkg-config \
    && docker-php-ext-install gd pdo mbstring

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Set correct permissions for the /app directory
RUN chown -R www-data:www-data /app \
    && chmod -R 755 /app

# Expose port 80 for the web server
EXPOSE 80

# Start the web server
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
