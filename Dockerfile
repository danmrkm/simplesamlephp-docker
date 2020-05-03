FROM php:7.4-apache

# パッケージのインストール
RUN apt-get update && \
    apt-get -y install curl mod_ssl --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Workdir
WORKDIR /var/simplesamlphp

# Apache の設定
COPY apache_conf/ports.conf /etc/apache2/
COPY apache/simplesamlphp.conf /etc/apache2/sites-available/
RUN a2enmod ssl && \
    a2dissite 000-default.conf default-ssl.conf && \
    a2ensite simplesamlphp.conf

# 証明書の設定
COPY pki/cert.crt /etc/ssl/cert/cert.crt
COPY pki/private.key /etc/ssl/private/private.key

# simplesamlphp のインストール
RUN curl -s -L -o simplesamlphp.tar.gz "https://simplesamlphp.org/download?latest" && \
    tar xzf simplesamlphp.tar.gz && \
    rm -f simplesamlphp.tar.gz  && \
    mv simplesamlphp-* /var/simplesamlphp && \
    touch /var/simplesamlphp/modules/exampleauth/enable
