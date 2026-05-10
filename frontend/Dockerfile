# ── STAGE 1: Preparar archivos ───────────────────────────
FROM alpine:latest AS builder

WORKDIR /app

COPY index.html app.js ./

# ── STAGE 2: Producción con Nginx ───────────────────────
FROM nginx:alpine AS production

# Usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Limpia contenido por defecto
RUN rm -rf /usr/share/nginx/html/*

# Copia archivos desde el stage builder
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/app.js /usr/share/nginx/html/

# Copia configuración de Nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Permisos al usuario
RUN chown -R appuser:appgroup /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]