LABEL org.opencontainers.image.authors="Alintya <alintya@users.noreply.github.com>"
# https://docs.typo3.org/m/typo3/guide-contributionworkflow/main/en-us/Appendix/Linux/SettingUpTypo3ManuallyLinux.html 

ARG TYPO_VERSION=12
# composer won't create symlinks without
ARG COMPOSER_ALLOW_ROOT=1

FROM composer:2 AS composer

FROM php:8.2-apache
WORKDIR /var/www/html

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
# Configure PHP
        libxml2-dev libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        zlib1g-dev \
# Install required 3rd party tools
        graphicsmagick \
        unzip \
        ghostscript
# Configure extensions
RUN docker-php-ext-configure gd --with-libdir=/usr/include/ --with-jpeg --with-freetype && \
    docker-php-ext-install -j$(nproc) pdo_mysql opcache gd zip intl pgsql pdo_pgsql pdo
#sqlite3 pdo_sqlite
# php extensions installed by default: spl, mbstring, filter, xml, session, fileinfo, standard, zlib, tokenizer, ?

RUN echo 'pcre.jit = 1\nalways_populate_raw_post_data = -1\nmemory_limit = 512M\nmax_execution_time = 240\nmax_input_vars = 1500\nupload_max_filesize = 32M\npost_max_size = 32M' > /usr/local/etc/php/conf.d/000-typo3.ini

# Clean up
RUN apt-get clean && \
    apt-get -y purge \
    libxml2-dev libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* /usr/src/*

# Configure Apache
COPY t3-apache.conf /etc/apache2/sites-available/t3-apache.conf
RUN a2dissite 000-default && \
    a2ensite t3-apache && \
    a2enmod rewrite deflate rewrite headers mime expires
# Get rid of server name warning
RUN echo "ServerName typo3" >> /etc/apache2/apache2.conf

# Install typo3 via composer
RUN composer create-project typo3/cms-base-distribution . "^12"

RUN cp vendor/typo3/cms-install/Resources/Private/FolderStructureTemplateFiles/root-htaccess public/.htaccess


RUN chown -R www-data: .

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 80

# Set the startup script as the entrypoint
ENTRYPOINT ["/usr/local/bin/startup.sh"]
