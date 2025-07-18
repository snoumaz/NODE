#!/bin/bash

echo "=== Construyendo imagen Docker ==="
docker build -t prexamen-app .

echo "=== Deteniendo contenedor anterior si existe ==="
docker stop prexamen-container 2>/dev/null || true
docker rm prexamen-container 2>/dev/null || true

echo "=== Ejecutando contenedor ==="
docker run -d \
  --name prexamen-container \
  -p 3000:3000 \
  -p 3306:3306 \
  prexamen-app

echo "=== Esperando a que el contenedor esté listo ==="
sleep 10

echo "=== Verificando logs del contenedor ==="
docker logs prexamen-container

echo "=== Contenedor ejecutándose ==="
echo "Aplicación disponible en: http://localhost:3000"
echo "Base de datos MySQL disponible en: localhost:3306"
echo ""
echo "Para ver logs en tiempo real: docker logs -f prexamen-container"
echo "Para acceder al contenedor: docker exec -it prexamen-container bash"
