FROM centos:7

LABEL maintainer="Omar Usman"
LABEL email="oomarusman@gmail.com"
LABEL twitter="https://twitter.com/oozman"

# Add repository and keys
RUN yum update
RUN yum -y install epel-release

# Install nginx
COPY .docker/nginx.repo /etc/yum.repos.d/nginx.repo
RUN yum -y install nginx

# Copy nginx conf
COPY .docker/server.conf /etc/nginx/conf.d/default.conf

# Install PHP 7.2
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php72
RUN yum -y install php
RUN yum -y install php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt php-intl php-cli php-fpm

# PHP-FPM needs this folder
RUN mkdir -p /run/php-fpm

# Install pip
RUN yum -y install python-pip
RUN pip install --upgrade pip

# Install supervisor
RUN pip install supervisor

# Copy supervisor conf
COPY .docker/supervisord.conf /etc/supervisord.conf

# Copy source code
COPY src /workspace

# Set folder permissions
# See: https://laracasts.com/discuss/channels/general-discussion/laravel-framework-file-permission-security
RUN chgrp -R apache /workspace/storage /workspace/bootstrap/cache
RUN chmod -R ug+rwx /workspace/storage /workspace/bootstrap/cache

# Add start script
COPY .docker/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

CMD ["/start.sh"]