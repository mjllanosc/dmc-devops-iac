#!/bin/sh
# Generate config.js with environment variables for nginx

# Prefer BACKEND_URL, then API_BASE_URL, then default to localhost for dev
BACKEND_URL="${BACKEND_URL:-${API_BASE_URL:-http://localhost:8080}}"

# Warn in logs if running with the default localhost value (likely a misconfiguration in prod)
if [ "$BACKEND_URL" = "http://localhost:8080" ] || [ -z "$BACKEND_URL" ]; then
  echo "WARNING: BACKEND_URL is not set or uses the default localhost value. Set BACKEND_URL to your backend FQDN in production."
fi

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
