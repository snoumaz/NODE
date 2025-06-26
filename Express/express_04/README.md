# 🌍 Express Travels CRUD

Una aplicación web completa para la gestión de viajes desarrollada con Node.js, Express y EJS.

![Node.js](https://img.shields.io/badge/Node.js-v18+-green.svg)
![Express.js](https://img.shields.io/badge/Express.js-v5.1-blue.svg)
![EJS](https://img.shields.io/badge/EJS-v3.1-orange.svg)
![License](https://img.shields.io/badge/License-ISC-yellow.svg)

## 📋 Descripción

Esta aplicación permite realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre un catálogo de viajes. Incluye un panel de administración completo con interfaz moderna, páginas individuales para cada destino, y una API REST completamente funcional.

### ✨ Características Principales

- 🔄 **CRUD Completo**: Crear, leer, actualizar y eliminar viajes
- 👨‍💼 **Panel de Administración**: Interfaz moderna e intuitiva para gestionar viajes
- 🛣️ **Rutas Dinámicas**: Páginas automáticas generadas para cada destino
- 🔌 **API REST**: Endpoints RESTful para operaciones asíncronas
- 📱 **Responsive Design**: Diseño completamente adaptable a todos los dispositivos
- ✅ **Validación de Datos**: Procesamiento seguro y validación de formularios
- 🎨 **UI Moderna**: Interfaz con gradientes, sombras y animaciones CSS
- ⚡ **Hot Reload**: Desarrollo rápido con auto-restart del servidor

## 🛠️ Tecnologías Utilizadas

### Backend

- **Node.js**: Runtime de JavaScript del lado del servidor
- **Express.js v5.1**: Framework web minimalista y flexible
- **EJS v3.1**: Motor de plantillas para renderizado dinámico
- **File System (fs)**: Manejo de archivos JSON como base de datos
- **Crypto**: Generación de IDs únicos seguros

### Frontend

- **HTML5**: Estructura semántica de las páginas
- **CSS3**: Estilos modernos con gradientes, flexbox y grid
- **JavaScript (Vanilla)**: Interactividad del lado del cliente
- **Fetch API**: Comunicación asíncrona con el servidor

### Herramientas de Desarrollo

- **Nodemon**: Auto-restart del servidor en desarrollo
- **Git**: Control de versiones
- **npm**: Gestión de dependencias

## 📁 Estructura del Proyecto

```
express_04/
├── app.js                 # Servidor principal Express
├── package.json           # Configuración del proyecto
├── .env                   # Variables de entorno
├── utils/
│   └── funciones.js       # Funciones utilitarias CRUD
├── data/
│   └── travels.json       # Base de datos JSON
├── views/
│   ├── admin.ejs          # Panel de administración
│   ├── travels.ejs        # Página individual de viaje
│   └── templates/         # Plantillas reutilizables
├── public/
│   ├── css/              # Hojas de estilo
│   ├── js/               # Scripts del cliente
│   └── img/              # Imágenes estáticas
└── README.md             # Este archivo
```

## ⚡ Instalación y Uso

### 📋 Prerrequisitos

- **Node.js** (versión 18 o superior) - [Descargar aquí](https://nodejs.org/)
- **npm** (incluido con Node.js)
- **Git** (opcional, para clonar el repositorio)

### 🚀 Instalación

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/classesdeferran/stucom_ej_2.git
   cd express_04
   ```

2. **Instalar dependencias**

   ```bash
   npm install
   ```

3. **Configurar variables de entorno**
   ```bash
   # El archivo .env ya está configurado con:
   PORT=1234
   ```

### 🎯 Ejecutar la aplicación

#### Modo desarrollo (recomendado para desarrollo)

```bash
npm run dev
```

_Incluye auto-restart cuando detecta cambios en los archivos_

#### Modo producción

```bash
npm start
```

#### Modo producción con variables de entorno

```bash
npm run prod
```

### 🌐 Acceder a la aplicación

- **Aplicación principal**: [http://localhost:1234](http://localhost:1234)
- **Panel de administración**: [http://localhost:1234/admin](http://localhost:1234/admin)
- **Ejemplo de destino**: [http://localhost:1234/madrid](http://localhost:1234/madrid)

## 📸 Screenshots y Características

### 🎨 Panel de Administración Moderno

- **Interfaz elegante**: Gradientes y sombras CSS modernas
- **Layout optimizado**: 66% tabla, 33% formularios
- **Efectos interactivos**: Hover effects y animaciones suaves
- **Botones estilizados**: Colores diferenciados (verde=crear, naranja=editar, rojo=eliminar)

### 🖼️ Páginas de Destinos

- **Imágenes centradas**: Máximo 800px con bordes redondeados
- **Navegación intuitiva**: Enlaces automáticos entre destinos
- **Diseño responsive**: Adaptable a todos los dispositivos

## 🔧 API Endpoints

### Rutas Principales

- `GET /` - Página principal
- `GET /admin` - Panel de administración
- `GET /:ruta` - Página individual de cada viaje

### API REST

- `POST /insert` - Crear nuevo viaje
- `PUT /update/:id` - Actualizar viaje existente
- `DELETE /delete/:id` - Eliminar viaje

## 📊 Estructura de Datos

Cada viaje tiene la siguiente estructura:

```json
{
  "id": "uuid-único",
  "lugar": "Madrid",
  "nombre": "Escapada a Madrid",
  "descripcion": "Descripción del viaje...",
  "precio": 299.99,
  "img": "/img/madrid.jpg",
  "ruta": "/madrid"
}
```

## 🎯 Funcionalidades Destacadas

### ⚡ Rendimiento y Optimización

- **Rutas dinámicas**: Generación automática de páginas para cada destino
- **Funciones utilitarias**: Código reutilizable y modular (`utils/funciones.js`)
- **Validación de tipos**: Conversión automática de precios a float
- **Archivos estáticos**: Servicio eficiente de CSS, JS e imágenes

### 🔒 Validación y Seguridad

- **Validación de formularios**: Procesamiento seguro de datos
- **IDs únicos**: Generación con `crypto.randomUUID()`
- **Sanitización**: Validación de rutas y campos obligatorios
- **Error handling**: Manejo de errores en peticiones AJAX

### 🎨 Experiencia de Usuario

- **Feedback visual**: Estados hover, focus y loading
- **Animaciones suaves**: Transiciones CSS de 0.3s
- **Responsive design**: Mobile-first approach
- **Accesibilidad**: Contrastes adecuados y navegación por teclado

## 🛠️ Comandos Útiles

```bash
# Desarrollo con watch mode
npm run dev

# Producción
npm start

# Producción con NODE_ENV
npm run prod

# Verificar estructura del proyecto
tree /F
```

## 🚀 Características Técnicas

- **Arquitectura MVC**: Separación clara de responsabilidades
- **RESTful API**: Endpoints siguiendo convenciones REST
- **File-based Database**: JSON como almacenamiento simple y eficiente
- **Template Engine**: EJS para renderizado dinámico del servidor
- **Modern CSS**: Flexbox, Grid, y características CSS3 avanzadas

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si quieres mejorar este proyecto:

1. **Fork el proyecto** 🍴
2. **Crea tu rama de feature** (`git checkout -b feature/AmazingFeature`)
3. **Commit tus cambios** (`git commit -m 'Add some AmazingFeature'`)
4. **Push a la rama** (`git push origin feature/AmazingFeature`)
5. **Abre un Pull Request** 🔄

### 💡 Ideas para contribuir

- Agregar autenticación de usuarios
- Implementar búsqueda y filtros
- Añadir más validaciones
- Mejorar el diseño responsive
- Agregar tests unitarios
- Implementar base de datos real (MongoDB, PostgreSQL)

## � Reportar Issues

Si encuentras algún bug o tienes sugerencias:

1. Verifica que no esté ya reportado en [Issues](https://github.com/classesdeferran/stucom_ej_2/issues)
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducirlo
   - Capturas de pantalla (si aplica)
   - Información del entorno (SO, versión de Node.js, etc.)

## �📝 Licencia

Este proyecto está bajo la **Licencia ISC**. Consulta el archivo `LICENSE` para más detalles.

## 👨‍💻 Autor y Créditos

**Ferran** - Desarrollo Principal

- GitHub: [@classesdeferran](https://github.com/classesdeferran)
- Proyecto educativo para aprendizaje de Node.js y Express

## 🔗 Enlaces Útiles

- 📁 [Repositorio del Proyecto](https://github.com/classesdeferran/stucom_ej_2)
- 🐛 [Reportar Bugs](https://github.com/classesdeferran/stucom_ej_2/issues)
- 📚 [Documentación de Express.js](https://expressjs.com/)
- 📖 [Documentación de EJS](https://ejs.co/)
- 🌐 [Node.js Official](https://nodejs.org/)

## 🎓 Propósito Educativo

Este proyecto fue desarrollado como parte del aprendizaje de:

- **Backend Development** con Node.js y Express
- **Template Engines** con EJS
- **REST APIs** y operaciones CRUD
- **Frontend Integration** con vanilla JavaScript
- **Modern CSS** y responsive design

---

### ⭐ ¡No olvides dar una estrella al proyecto si te ha sido útil!

**¿Te gustó el proyecto?** Considera:

- ⭐ Darle una estrella en GitHub
- 🔄 Compartirlo con otros desarrolladores
- 💬 Dejar feedback en los issues
- 🤝 Contribuir con mejoras

---

_Desarrollado con ❤️ para la comunidad de estudiantes de desarrollo web_
