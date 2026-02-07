# Saludo Service

Servicio Spring Boot simple que expone un endpoint `/saludo`.

Construir y ejecutar localmente (requiere Maven y Docker):

1) Compilar JAR con Maven

```bash
mvn clean package -DskipTests
```

2) Ejecutar con Maven directamente (sin Docker)

```bash
mvn spring-boot:run
# luego abrir http://localhost:8080/saludo
```

3) Construir imagen Docker

```bash
docker build -t saludo-service:latest .
```

4) Ejecutar contenedor Docker

```bash
docker run -p 8080:8080 saludo-service:latest
# luego abrir http://localhost:8080/saludo
```
