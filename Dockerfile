FROM ubuntu:14.04

MAINTAINER RadicalRad <rad@mira-digital.com>

ENV DEBIAN_FRONTEND noninteractive

#Install nginx and php
RUN apt-get update && \
	apt-get install -y \
	nginx \
	php5 \
	php5-fpm \
	php5-cli \	
	php5-curl \
	php5-mysql \
	php5-mcrypt \
	supervisor
RUN mv -i /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/

#Create web folder
RUN mkdir -p /var/www/html /var/log/supervisor

#Add supervisord.conf

COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY php.ini /etc/php5/fpm/php.ini
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY default /etc/nginx/sites-available/default

#Share web folder
VOLUME ["/var/www/html"]

#Set port
EXPOSE 80 443

#Start supervisor
CMD ["/usr/bin/supervisord"]
