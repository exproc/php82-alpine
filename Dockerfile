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
    php82-pecl-xmlrpc  \
 echo "**** configure nginx ****" && \
  echo 'fastcgi_param  HTTP_PROXY         ""; # https://httpoxy.org/' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info; # http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name; # https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/#connecting-nginx-to-php-fpm' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SERVER_NAME        $host; # Send HTTP_HOST as SERVER_NAME. If HTTP_HOST is blank, send the value of server_name from nginx (default is `_`)' >> \
    /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/conf.d/stream.conf && \
  rm -f /etc/nginx/http.d/default.conf && \
  echo "**** configure php ****" && \
  sed -i "s#;error_log = log/php81/error.log.*#error_log = /config/log/php/error.log#g" \
    /etc/php82/php-fpm.conf && \
  sed -i "s#user = nobody.*#user = abc#g" \
    /etc/php82/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = abc#g" \
    /etc/php82/php-fpm.d/www.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" \
    /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
    /etc/periodic/daily/logrotate
   

COPY root/ /
ENTRYPOINT ["/init"] 
# ports and volumes

#VOLUME /config

EXPOSE 80 443 9000 69/udp