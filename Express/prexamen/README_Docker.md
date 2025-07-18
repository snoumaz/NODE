# Prexamen - Aplicación con Docker

Esta aplicación incluye una API REST con Express.js y una base de datos MySQL, todo configurado para ejecutarse en Docker.

## Requisitos

- Docker instalado en tu sistema
- Docker Compose (opcional, para desarrollo)

## Ejecución Rápida

### Opción 1: Script automático (Recomendado)

**Linux/Mac:**
```bash
# Dar permisos de ejecución al script
chmod +x build-and-run.sh

# Ejecutar el script
./build-and-run.sh
```

**Windows (PowerShell):**
```powershell
# Ejecutar el script de PowerShell
.\build-and-run.ps1
```

### Opción 2: Comandos manuales

```bash
# Construir la imagen
docker build -t prexamen-app .

# Ejecutar el contenedor
docker run -d \
  --name prexamen-container \
  -p 3002:3002 \
  -p 3306:3306 \
  prexamen-app
```

## Verificación

Una vez ejecutado el contenedor:

1. **Aplicación web**: http://localhost:3002
2. **API endpoints**:
   - `GET /alumnos` - Lista todos los alumnos
   - `GET /alumnos/:apellido1` - Busca alumnos por apellido
   - `GET /profesor/:apellido1/:nombre` - Busca profesor y sus asignaturas

## Comandos útiles

```bash
# Ver logs del contenedor
docker logs prexamen-container

# Ver logs en tiempo real
docker logs -f prexamen-container

# Acceder al contenedor
docker exec -it prexamen-container bash

# Detener el contenedor
docker stop prexamen-container

# Eliminar el contenedor
docker rm prexamen-container

# Eliminar la imagen
docker rmi prexamen-app
```

## Solución de problemas

### La base de datos no se conecta

1. Verifica que el contenedor esté ejecutándose:

   ```bash
   docker ps
   ```

2. Revisa los logs del contenedor:

   ```bash
   docker logs prexamen-container
   ```

3. Si hay errores de inicialización, reinicia el contenedor:
   ```bash
   docker restart prexamen-container
   ```

### Puerto ya en uso

Si el puerto 3002 o 3306 ya están en uso, puedes cambiar los puertos:

```bash
docker run -d \
  --name prexamen-container \
  -p 3003:3002 \
  -p 3307:3306 \
  prexamen-app
```

## Estructura del proyecto

```
prexamen/
├── app.js                 # Servidor Express
├── dockerfile            # Configuración de Docker
├── start.sh              # Script de inicio del contenedor
├── build-and-run.sh      # Script de construcción y ejecución
├── package.json          # Dependencias de Node.js
├── sql/
│   ├── conexion.js       # Configuración de conexión a MySQL
│   ├── init.sql          # Script de inicialización de la BD
│   ├── alumnos.txt       # Datos de alumnos
│   ├── telefonosContacto.csv # Datos de teléfonos
│   └── impartir.txt      # Datos de asignaturas impartidas
└── public/               # Archivos estáticos
```

## Variables de entorno

Las variables de entorno se configuran automáticamente en el contenedor:

- `DB_HOST=localhost`
- `DB_USER=root`
- `DB_PASS=root`
- `DB_PORT=3306`
- `DB_NAME=Facultad`
