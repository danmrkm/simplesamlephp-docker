FROM php:7.4-apache

# パッケージのインストール
RUN apt-get update && \
    apt-get -y install curl mod_ssl --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Workdir
WORKDIR /var/simplesamlphp

# Apache の設定
COPY ./apache2_conf/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2_conf/envvars /etc/apache2/envvars
COPY ./apache2_conf/ports.conf /etc/apache2/ports.conf
COPY ./apache2_conf/sites-available/* /etc/apache2/sites-available/
COPY ./apache2_conf/conf-available/* /etc/apache2/conf-available/
COPY ./apache2_conf/mods-available/* /etc/apache2/mods-available/
RUN a2enmod authz_host rewrite ssl headers alias; &&\
    a2disconf serve-cgi-bin; &&\
    a2dissite 000-default.conf && \
    a2ensite simplesamlphp.conf

# 証明書の設定
COPY ./pki/*.crt /etc/ssl/cert/
COPY ./pki/*.key /etc/ssl/private/

# simplesamlphp のインストール
RUN curl -s -L -o simplesamlphp.tar.gz "https://simplesamlphp.org/download?latest" && \
    tar xzf simplesamlphp.tar.gz && \
    rm -f simplesamlphp.tar.gz  && \
    mv simplesamlphp-* /var/simplesamlphp && \
    touch /var/simplesamlphp/modules/exampleauth/enable
