#!/bin/bash

echo "[INFO] Iniciando MySQL..."
service mysql start

# Esperar a que MySQL arranque completamente
echo "[INFO] Esperando a que MySQL esté listo..."
for i in {1..30}; do
    if mysql -uroot -proot -e "SELECT 1" >/dev/null 2>&1; then
        echo "[INFO] MySQL está listo"
        break
    fi
    echo "[INFO] Esperando MySQL... ($i/30)"
    sleep 2
done

# Establecer contraseña de root si no está configurada
echo "[INFO] Configurando contraseña del root..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

# Crear base de datos si no existe
echo "[INFO] Creando base de datos si no existe..."
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS Facultad; USE Facultad;"

# Ejecutar script SQL inicial
echo "[INFO] Cargando init.sql..."
if mysql -uroot -proot < /usr/src/app/sql/init.sql; then
    echo "[INFO] Base de datos inicializada correctamente"
else
    echo "[ERROR] Error al inicializar la base de datos"
    exit 1
fi

echo "[INFO] Iniciando servidor Node.js..."
npm start
