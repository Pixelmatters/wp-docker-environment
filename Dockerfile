FROM php:5.6-apache

# Enable Apache mod_rewrite and mod_expires
RUN a2enmod rewrite expires

# Install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mysqli opcache

# Set recommended PHP.ini settings
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Copy code files to apache default directory and set proper permissions
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Replace default apache virtualhost by ours
COPY ./docker/conf/000-default.conf /etc/apache2/sites-available/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN service apache2 restart
