FROM debian:9

WORKDIR /var/www/html

# install pre-requisites
RUN apt-get update > /dev/null \
    && apt-get install --assume-yes \
        apache2 \
        cron \
        wget \
        curl \
        git \
        zip \
        unzip \
        gnupg \
        cron  \
        vim \
        apt-transport-https\
        > /dev/null

# install php
RUN curl https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" \
    | tee /etc/apt/sources.list.d/php5.list \
        && apt-get update > /dev/null \
        && apt-get install --assume-yes \
    php7.0 > /dev/null

#install modules
RUN apt install --assume-yes \
        php7.0-zip \
        php7.0-xml \
        php7.0-mcrypt \
        php7.0-imap \
        php7.0-mailparse \
        php7.0-opcache \
        php7.0-curl \
        php7.0-apcu \
        php7.0-pdo-mysql \
        > /dev/null

 #install composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=compose

#install mautic
RUN wget https://github.com/mautic/mautic/releases/download/2.15.2/2.15.2.zip \
    && unzip 2.15.2.zip -d ./

#ĩnstall whitelabeler
RUN git clone https://github.com/nickian/mautic-whitelabeler.git

#import cron
COPY cron /var/www/html
RUN cat cron | crontab -


#permissions apache
RUN rm -f index.html \
    && chown -R www-data. ./
RUN chmod -R 777 /var/www/html

#enable module apache

RUN  a2enmod rewrite

#start cron
RUN service cron start 

#ENTRYPOINT [ "service", "cron","restart"]
CMD service cron restart  && apache2ctl -D FOREGROUND






