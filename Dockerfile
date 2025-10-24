# PHP 8.1 ve Apache tabanlı resmi imajı kullanın
FROM php:8.1-apache

# Gerekli kütüphaneleri ve araçları yükleyin
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql

# Composer'ı yükleyin
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Apache mod_rewrite modülünü etkinleştirin
RUN a2enmod rewrite

# Çalışma dizinini ayarlayın
WORKDIR /var/www/html

# Proje dosyalarınızı konteyner içine kopyalayın
COPY . /var/www/html

# Composer'ı süper kullanıcı olarak çalıştırmaya izin verin
ENV COMPOSER_ALLOW_SUPERUSER=1

# Gerekli bağımlılıkları yükleyin
RUN if [ -f composer.json ]; then composer install; fi

# 80 numaralı portu dinleyin
EXPOSE 80

# Apache'yi başlatın
CMD ["apache2-foreground"]