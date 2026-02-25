# Guía de Despliegue y Actualización

## Pasos para actualizar la aplicación

### 1. Descargar los últimos cambios

Primero, descarga la última versión del código desde el repositorio.

```bash
git pull origin main
```

### 2. Generar y configurar variables de entorno

```bash
cp .env.example .env
```

### 3.Construir y levantar los contenedores

Reconstruir la imagen asegurando que toma los últimos cambios base

```bash
docker compose build
```

Levantar el contenedor en segundo plano

```bash
docker compose up -d
```

### 4. Instalar dependencias

```bash
docker exec -it webserver composer install --optimize-autoloader
```
