ARG WORDPRESS_VERSION=5.7.2
ARG PHP_VERSION=8.0

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-apache

ARG IMAGICK_VERSION=3.4.4
ARG MAX_UPLOAD=256M
ARG MAX_MEMORY=512M
ARG MAX_TIME=180

LABEL org.opencontainers.image.source https://github.com/aperim/docker-wordpress
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Wordpress Apache with ModRewrite and PDO_MYSQL" \
  org.label-schema.description="Wordpress Apache with ModRewrite and PDO_MYSQL" \
  org.label-schema.url="https://github.com/aperim/docker-wordpress" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-wordpress" \
  org.label-schema.vendor="Aperim" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

RUN apt-get update && \
  apt-get install -y libzstd-dev/stable && \
  apt-get install -y libmagickwand-dev build-essential --no-install-recommends

RUN mkdir -p /usr/src/php/ext/imagick; \
    echo "Downloading https://github.com/Imagick/imagick/archive/${IMAGICK_VERSION}.tar.gz"; \
    curl -fsSL https://github.com/Imagick/imagick/archive/${IMAGICK_VERSION}.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1

RUN docker-php-ext-install pdo_mysql imagick && \
  printf "memory_limit = ${MAX_MEMORY}\n\nupload_max_filesize = ${MAX_UPLOAD}\npost_max_size = ${MAX_UPLOAD} \nmax_file_uploads = ${MAX_UPLOAD}\n\nmax_input_time = ${MAX_TIME}\nmax_execution_time = ${MAX_TIME}\n\nmax_input_vars = 5000" > /usr/local/etc/php/conf.d/aperim.ini && \
  printf "extension=redis.so\nextension=igbinary.so\n" > /usr/local/etc/php/conf.d/redis.ini && \
	a2enmod remoteip; \
	{ \
		echo 'RemoteIPHeader X-Forwarded-For'; \
	} > /etc/apache2/conf-available/remoteip.conf; \
	a2enconf remoteip && \
  yes | pecl install igbinary && \
  yes | pecl install redis

RUN apt-get remove -y build-essential && \
  rm -rf /var/lib/apt/lists/*
