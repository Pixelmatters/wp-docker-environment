FROM php:5.6-apache

# Enable Apache mod_rewrite and mod_expires
RUN a2enmod rewrite expires

# Install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli  # opcache

# Copy code files to apache default directory and set proper permissions
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Replace default apache virtualhost by ours
COPY ./docker/conf/000-default.conf /etc/apache2/sites-available/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN service apache2 restart
