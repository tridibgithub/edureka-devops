FROM devopsedu/webapp
WORKDIR /var/www/html
copy . /var/www/html
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
