#!/bin/sh
# Generate config.js with environment variables for nginx

BACKEND_URL="${BACKEND_URL:-http://localhost:8080}"

cat > /usr/share/nginx/html/config.js << EOF
// Configuration generated at runtime
window.apiConfig = {
    apiBaseUrl: '$BACKEND_URL',
    endpoints: {
        saludo: '/saludo',
        mostrarSecreto: '/mostrar_secreto'
    }
};
EOF

echo "Generated config.js with BACKEND_URL: $BACKEND_URL"

# Start nginx
nginx -g 'daemon off;'
