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

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
  apt-get install -y libldb-dev=2:2.2.3-2~deb11u2 libldap-common=2.4.57+dfsg-3+deb11u1 libldap2-dev=2.4.57+dfsg-3+deb11u1 libzstd-dev=1.4.8+dfsg-2.1 --no-install-recommends && \
  apt-get install -y libmagickwand-dev=8:6.9.11.60+dfsg-1.3 build-essential=12.9 --no-install-recommends && \
  mkdir -p /usr/src/php/ext/imagick; \
  echo "Downloading https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz"; \
  curl -fsSL https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 && \
  docker-php-ext-install ldap pdo_mysql imagick && \
  printf "memory_limit = \${PHP_MEMORY_LIMIT}\n\nupload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}\npost_max_size = \${PHP_POST_MAX_SIZE} \nmax_file_uploads = \${PHP_MAX_FILE_UPLOADS}\n\nmax_input_time = \${PHP_MAX_INPUT_TIME}\nmax_execution_time = \${PHP_MAX_EXECUTION_TIME}\n\nmax_input_vars = \${PHP_MAX_INPUT_VARS}\n\n" > /usr/local/etc/php/conf.d/aperim.ini && \
  printf "extension=redis.so\nextension=igbinary.so\n" > /usr/local/etc/php/conf.d/redis.ini && \
  touch /usr/local/etc/php/conf.d/pear.ini && \
	a2enmod remoteip; \
	{ \
		echo 'RemoteIPHeader X-Forwarded-For'; \
	} > /etc/apache2/conf-available/remoteip.conf; \
	a2enconf remoteip && \
  pear config-set php_ini /usr/local/etc/php/conf.d/pear.conf && \
  pecl install igbinary && \
  pecl install redis && \
  apt-get remove -y build-essential && \
  rm -rf /var/lib/apt/lists/*

ARG BUILD_DESCRIPTION="WordPress version ${WORDPRESS_VERSION} with imagemagick and redis support"
ARG BUILD_NAME="WordPress ${WORDPRESS_VERSION}"
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

LABEL \
    maintainer="Troy Kelly <troy@aperim.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Troy Kelly" \
    org.opencontainers.image.authors="Troy Kelly <troy@aperim.com>" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://aperim.com" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
