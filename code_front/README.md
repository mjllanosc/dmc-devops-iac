# Frontend - Aplicación Web Saludo

## 📌 Descripción

Aplicación web estática servida por Nginx que proporciona una interfaz para consumir los endpoints del microservicio backend.

## 🎨 Características

- ✅ **Interfaz Responsiva**: Diseño moderno y adaptable
- ✅ **Carga Automática**: Subtítulo que carga automáticamente el servicio `/saludo`
- ✅ **Botón Interactivo**: "Mostrar secreto" consume `/mostrar_secreto`
- ✅ **Caja de Salida**: Muestra respuestas con estilos diferenciados (éxito/error)
- ✅ **Configuración Dinámica**: URL del backend se inyecta dinámicamente
- ✅ **Footer con Autoría**: Créditos al autor

## 🛠️ Stack Tecnológico

- **Servidor Web**: Nginx (Alpine)
- **Frontend**: HTML5 + CSS3 + JavaScript ES6
- **Configuración**: Dinámicamente generada via variables de entorno

## 📁 Estructura

```
code_front/
├── index.html           # Página principal
├── styles.css           # Estilos CSS
├── config.js            # Configuración dinámica (generada)
├── start.sh             # Script de arranque
├── Dockerfile           # Build Docker
├── .dockerignore        # Archivos a excluir
└── README.md            # Este archivo
```

## 📄 Archivos

### index.html
Página principal que:
- Carga `config.js` para obtener la URL del backend
- Importa `styles.css` para estilos
- Implementa dos funciones JavaScript:
  - `obtenerSaludo()`: Carga automáticamente al inicializar
  - `obtenerSecreto()`: Ejecuta al hacer clic en el botón

### styles.css
Hojas de estilos con:
- Gradiente de fondo (morado)
- Layout flexbox responsivo
- Animaciones (cargando, hover)
- Estilos para éxito/error
- Media queries para móviles

### config.js
Archivo de configuración que contiene:
```javascript
window.apiConfig = {
    apiBaseUrl: 'http://localhost:8080',  // URL del backend
    endpoints: {
        saludo: '/saludo',
        mostrarSecreto: '/mostrar_secreto'
    }
};
```

**Nota:** Se genera dinámicamente en `start.sh` basado en `BACKEND_URL`

### start.sh
Script que:
1. Lee variable `BACKEND_URL` (por defecto: `http://localhost:8080`)
2. Genera `config.js` dinámicamente
3. Inicia Nginx

## 🚀 Ejecución Local

### Opción 1: Docker (recomendado)
```bash
# Build
docker build -t code-front-saludo:latest .

# Run sin variable (usa localhost:8080)
docker run -d -p 8081:80 \
  --name frontend \
  code-front-saludo:latest

# Run con variable personalizada
docker run -d -p 8081:80 \
  -e BACKEND_URL="http://localhost:8080" \
  --name frontend \
  code-front-saludo:latest

# Acceder
# http://localhost:8081
```

### Opción 2: Servidor local (desarrollo)
```bash
cd code_front
python -m http.server 8081
# http://localhost:8081
```

## 🌍 Variables de Entorno

| Variable | Requerida | Ejemplo | Descripción |
|---|---|---|---|
| `BACKEND_URL` | No | `http://localhost:8080` | URL base del backend (se inyecta en config.js) |

## 📦 Docker Hub

**Imagen publicada:**
```
mjllanosc/app-front-saludo-01:v1.0
```

Para usar:
```bash
docker run -d -p 8081:80 \
  -e BACKEND_URL="http://backend-url:8080" \
  mjllanosc/app-front-saludo-01:v1.0
```

## 🎯 Flujo de Uso

1. Usuario abre la aplicación en el navegador
2. Se ejecuta `obtenerSaludo()` automáticamente
   - Petición GET a `${API_BASE_URL}/saludo`
   - Muestra respuesta en el subtítulo
3. Usuario hace clic en "Mostrar secreto"
   - Petición GET a `${API_BASE_URL}/mostrar_secreto`
   - Muestra respuesta en la caja de salida
   - Color verde si tiene éxito, rojo si error

## 🔍 Debugging

### Verificar configuración
Abre la consola del navegador (F12) y ejecuta:
```javascript
console.log(window.apiConfig);
```

### Logs del contenedor
```bash
docker logs -f frontend
```

### Test de conectividad
```bash
curl http://localhost:8081/config.js
```

## 📝 Puertos

- **Interno (container)**: `80` (Nginx)
- **Externo (host local)**: `8081` (configurable)
- **Externo (Azure)**: DNS FQDN asignado por Azure

## 🐳 Dockerfile

```dockerfile
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html
COPY styles.css /usr/share/nginx/html/styles.css
COPY config.js /usr/share/nginx/html/config.js
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 80
CMD ["/start.sh"]
```

## 🧹 Limpiar

```bash
docker stop frontend
docker rm frontend
docker rmi code-front-saludo:latest
```

## 🔗 Links Útiles

- [Nginx Documentation](https://nginx.org/en/docs/)
- [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [CSS Flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)
- [Docker Nginx](https://hub.docker.com/_/nginx)
