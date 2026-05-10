# ── STAGE 1: Instalar dependencias ──────────────────────
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY server.js ./

# ── STAGE 2: Producción ─────────────────────────────────
FROM node:18-alpine AS production

# Usuario no root (buena práctica de seguridad)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/server.js ./

# Asignar permisos al usuario
RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 3001

CMD ["npm", "start"]