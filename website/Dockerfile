# Use the official PHP image with Apache
FROM php:8.1-apache

# Install any necessary PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html/

# Set the working directory
WORKDIR /var/www/html/

# Ensure that the Apache server runs in the foreground
CMD ["apache2-foreground"]

# Expose port 80 to the host
EXPOSE 80
