
FROM php:8.2-apache
WORKDIR /var/www/html
COPY website/ /var/www/html/
RUN a2enmod rewrite
EXPOSE 80