############################
# Container APACHE #
############################

FROM php:7.4-apache

ARG WEB_USER_DIR=/var/www
ARG APP_DIR=app
ARG APACHE_LOG_DIR=/var/logs/apache2
ARG APACHE_ROOT_DIR=/usr/local/apache2
ARG DOCKER_LOCAL_PATH=.docker/apache/
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG WEB_UID=1000
ARG WEB_GID=1000
ARG NODE_CONSERTO_USER
ARG NODE_CONSERTO_PASSWORD

############################
# PHP Core Extensions      #
############################
WORKDIR ${WEB_USER_DIR}/${APP_DIR}

#############
## USER
#############
# Modification des ids www-data:www-data pour droits de partage;
RUN set -xe; \
    usermod -u ${WEB_UID} ${WEB_USER}; \
    groupmod -g ${WEB_GID} ${WEB_GROUP}; \
    chown ${WEB_USER}:${WEB_GROUP} ${WEB_USER_DIR}


############################
# PHP Core Extensions      #
############################
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libpq-dev \
        libbz2-dev \
        libzip-dev \
        libonig-dev \
        libxml2-dev \
        unzip \
        wget \
        git \
        vim \
        mariadb-client-10.3 \
    && docker-php-ext-install -j$(nproc) iconv intl opcache pdo_pgsql bz2 json zip exif bcmath sockets soap \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16



#############
## CONF PHP
#############
COPY ${DOCKER_LOCAL_PATH}/apache/etc/php.ini /usr/local/etc/php/conf.d/php.ini

#############
## CONF APACHE
#############
# Create logs path
RUN mkdir -p ${APACHE_LOG_DIR}
COPY ${DOCKER_LOCAL_PATH}/apache/conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ${DOCKER_LOCAL_PATH}/apache/conf/ports.conf /etc/apache2/ports.conf
RUN sed -ri -e "s!/var/www/!${WEB_USER_DIR}/${APP_DIR}/web/!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
ENV APACHE_ENV=${APACHE_ENV:-back}



#############
# Construct project
#############
# Droit sur le répertoire de l'app

# Droits sur les rep executables.
RUN set -xe; \
    mkdir -p ${WEB_USER_DIR}/${APP_DIR}/web/modules/contrib; \
    mkdir -p ${WEB_USER_DIR}/${APP_DIR}/web/core; \
    mkdir -p ${WEB_USER_DIR}/${APP_DIR}/vendor;

# Utilisation du user www-data
USER ${WEB_USER}

# Binaires accessibles.
ENV PATH="${WEB_USER_DIR}/${APP_DIR}/vendor/bin:${PATH}"


#############
# Set HEALTHCHECK
#############
#HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=10 CMD curl -f http://localhost:80/ || exit 1

USER root

COPY ${DOCKER_LOCAL_PATH}/apache/custom_entrypoint.sh /custom_entrypoint.sh
RUN chmod +x /custom_entrypoint.sh

ENTRYPOINT ["/custom_entrypoint.sh"]


