FROM debian:stretch-slim

ARG MT_VERSION
ENV MT_VERSION ${MT_VERSION:-7.4.0}

COPY [ "./docker-entrypoint.sh", "./cpanfile", "/" ]

RUN apt-get update -y \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates \
      apache2 \
      curl \
      gcc \
      libxml2-dev \
      libssl-dev \
      libexpat1-dev \
      make \
      libmariadbclient-dev \
      zip \
      php php-cli php-mbstring php-mysqlnd php-gd \
 && curl -sL --compressed https://git.io/cpm > cpm && chmod +x cpm && mv cpm /usr/local/bin/ \
 && sed -i \
  -e 's/ServerTokens OS/ServerTokens ProductOnly/g' \
  -e 's/ServerSignature On/ServerSignature Off/g' \
  /etc/apache2/conf-available/security.conf \
  && a2enmod mpm_prefork cgi rewrite php7.0 \
  && cpm install -g \
  && apt-get purge -y --auto-remove gcc libxml2-dev libssl-dev libexpat1-dev make libmariadbclient-dev libicu-dev gcc-6 \
  && apt-get autoclean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /root/.perl-cpm

ADD https://github.com/movabletype/movabletype/archive/mt${MT_VERSION}.tar.gz /usr/local/src

EXPOSE 80

WORKDIR /var/www/html

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "/usr/sbin/apache2ctl", "-DFOREGROUND" ]

