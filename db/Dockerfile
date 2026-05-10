# ── STAGE 1: Preparar script SQL ────────────────────────
FROM alpine:latest AS builder

WORKDIR /docker-entrypoint-initdb.d
COPY init.sql .

# ── STAGE 2: Imagen final MySQL ─────────────────────────
FROM mysql:8 AS production

# Las credenciales van en docker-compose.yml via variables de entorno
# NO se definen aquí para no exponerlas en el repositorio

# Copia el script de inicialización desde el stage builder
COPY --from=builder /docker-entrypoint-initdb.d/init.sql \
     /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306