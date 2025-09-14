# Use the official PHP image with Apache
FROM php:7.4-apache

# Copy project files into the default Apache web directory
COPY . /var/www/html/

# Set correct permissions (optional, but good practice)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose Apache HTTP port
EXPOSE 80

# Start Apache (handled by base image)
CMD ["apache2-foreground"]
