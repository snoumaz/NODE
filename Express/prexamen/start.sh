#!/bin/bash
#!/bin/bash

echo "[INFO] Iniciando MySQL..."
service mysql start

# Esperar a que MySQL arranque
echo "[INFO] Esperando a que MySQL esté listo..."
sleep 5

# Establecer contraseña de root si no está configurada
echo "[INFO] Configurando contraseña del root..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

# Crear base de datos si no existe
echo "[INFO] Creando base de datos si no existe..."
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS facultad;"

# (Opcional) Ejecutar script SQL inicial
# echo "[INFO] Cargando init.sql..."
# mysql -uroot -proot universidad < /usr/src/app/sql/init.sql

echo "[INFO] Iniciando servidor Node.js..."
npm start

