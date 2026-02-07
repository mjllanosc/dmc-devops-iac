# Simple Dockerfile to serve the static frontend with nginx
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy only the necessary static files
COPY index.html /usr/share/nginx/html/index.html
COPY styles.css /usr/share/nginx/html/styles.css
COPY config.js /usr/share/nginx/html/config.js

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose HTTP port
EXPOSE 80

# Run the startup script (generates config.js from env vars and starts nginx)
CMD ["/start.sh"]
