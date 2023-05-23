FROM ghcr.io/exproc/base

ARG MODS_VERSION="v3"
ARG PKG_INST_VERSION="v1"

ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/docker-mods.${MODS_VERSION}" "/docker-mods"
ADD --chmod=744 "https://raw.githubusercontent.com/linuxserver/docker-mods/mod-scripts/package-install.${PKG_INST_VERSION}" "/etc/s6-overlay/s6-rc.d/init-mods-package-install/run"

ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
  HOME="/root" \
  TERM="xterm" \
  S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
  S6_VERBOSITY=1 \
  S6_STAGE2_HOOK=/docker-mods \
  VIRTUAL_ENV=/lsiopy \
  PATH="/lsiopy/bin:$PATH"

RUN apk add --no-cache  \
    s6 \
    s6-overlay \
    openssl \
    php82-bcmath \
    php82-bz2 \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-ftp \
    php82-gd \
    php82-gmp \
    php82-iconv \
    php82-imap \
    php82-intl \
    php82-ldap \
    php82-mysqli \
    php82-mysqlnd \
    php82-opcache \
    php82-pdo_mysql \
    php82-pdo_odbc \
    php82-pdo_pgsql \
    php82-pdo_sqlite \
    php82-pear \
    php82-sysvsem \
    php82-fileinfo \
    php82-simplexml \
    php82-pecl-apcu \
    php82-pecl-memcached \
    php82-pecl-redis \
    php82-pgsql \
    php82-phar \
    php82-posix \
    php82-soap \
    php82-sockets \
    php82-sodium \
    php82-sqlite3 \
    php82-tokenizer \
    php82-xmlreader \
    php82-xmlwriter \
    php82-xsl \
    php82-zip \
    php82-fpm\
    openssl \
    logrotate \
    nginx  \
    php82-gettext \
    tftp-hpa \
    php82-pecl-imagick 
    RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \    
    php82-pecl-mcrypt \
    php82-pecl-xmlrpc  

   

COPY root/ /
ENTRYPOINT ["/init"] 
# ports and volumes

#VOLUME /config

EXPOSE 80 443 9000 69/udp