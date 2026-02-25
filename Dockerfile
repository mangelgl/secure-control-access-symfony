# Utilizamos una imagen oficial de PHP 8.1 como imagen base
FROM php:8.4-apache

# Instalamos los paquetes necesarios
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libpq-dev \
    git \ 
    curl \
    vim \
    unzip \
&& rm -rf /var/lib/apt/lists/* \
# Configuramos los módulos de PHP
&& docker-php-ext-install pdo pdo_mysql pdo_pgsql \
# Habilita mod_rewrite
&& a2enmod rewrite \
# Establecemos la raíz web de Apache en el directorio público del proyecto
&& sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
&& sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Instala composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiamos la configuración de Apache personalizada al contenedor
COPY web/apache2.conf /etc/apache2/apache2.conf

# Copiamos nuestra aplicación a la carpeta de trabajo del contenedor
COPY . /var/www/html/

# Establecemos la carpeta de trabajo
WORKDIR /var/www/html/

# Ejecutamos los comandos necesarios para instalar las dependencias de PHP y ejecutar nuestro proyecto
RUN composer install --optimize-autoloader \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html/var


# Exponemos el puerto 80 para el tráfico HTTP
EXPOSE 80

# Iniciamos el servidor Apache en primer plano
CMD ["apache2-foreground"]  
