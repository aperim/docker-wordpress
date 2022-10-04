ARG WORDPRESS_VERSION=6.0.2
ARG PHP_VERSION=8.1

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-apache

ARG IMAGICK_VERSION=3.7.0
ARG PHP_MEMORY_LIMIT=512M
ARG PHP_UPLOAD_MAX_FILESIZE=2048M
ARG PHP_POST_MAX_SIZE=${PHP_UPLOAD_MAX_FILESIZE}
ARG PHP_MAX_FILE_UPLOADS=${PHP_UPLOAD_MAX_FILESIZE}
ARG PHP_MAX_EXECUTION_TIME=600
ARG PHP_MAX_INPUT_TIME=${PHP_MAX_EXECUTION_TIME}
ARG PHP_MAX_INPUT_VARS=5000

ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT}
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_MEMORY_LIMIT}
ENV PHP_POST_MAX_SIZE=${PHP_UPLOAD_MAX_FILESIZE}
ENV PHP_MAX_FILE_UPLOADS=${PHP_UPLOAD_MAX_FILESIZE}
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME}
ENV PHP_MAX_INPUT_TIME=${PHP_MAX_EXECUTION_TIME}
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS}

LABEL org.opencontainers.image.source https://github.com/aperim/docker-wordpress
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Wordpress ${WORDPRESS_VERSION} Apache" \
  org.label-schema.description="Wordpress ${WORDPRESS_VERSION} PHP ${PHP_VERSION} Apache with ModRewrite and PDO_MYSQL" \
  org.label-schema.url="https://github.com/aperim/docker-wordpress" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-wordpress" \
  org.label-schema.vendor="Aperim" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"

RUN apt-get update && \
  apt-get install -y libzstd-dev/stable=1.4.8+dfsg-2.1 && \
  apt-get install -y libmagickwand-dev=8:6.9.11.60+dfsg-1.3 build-essential=12.9 --no-install-recommends && \
  mkdir -p /usr/src/php/ext/imagick; \
  echo "Downloading https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz"; \
  curl -fsSL https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1

RUN docker-php-ext-install pdo_mysql imagick && \
  printf "memory_limit = \${PHP_MEMORY_LIMIT}\n\nupload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}\npost_max_size = \${PHP_POST_MAX_SIZE} \nmax_file_uploads = \${PHP_MAX_FILE_UPLOADS}\n\nmax_input_time = \${PHP_MAX_INPUT_TIME}\nmax_execution_time = \${PHP_MAX_EXECUTION_TIME}\n\nmax_input_vars = \${PHP_MAX_INPUT_VARS}" > /usr/local/etc/php/conf.d/aperim.ini && \
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
