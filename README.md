# Innovatech
Aplicación web CRUD contenedorizada con Docker, desplegada en AWS EC2 mediante pipeline CI/CD con GitHub Actions.

## Arquitectura

## Servicios

| Servicio | Tecnología | Puerto |
|----------|-----------|--------|
| Frontend | Nginx + HTML/JS | 80 |
| Backend | Node.js + Express | 3001 |
| Base de datos | MySQL 8 | 3306 |

## Requisitos previos

- Docker instalado en cada EC2
- AWS CLI instalado en cada EC2 (para autenticación con ECR)
- Variables de entorno configuradas

## Levantar cada servicio

### Base de datos
```bash
cd db
docker compose up -d
```

### Backend
```bash
cd backend
docker compose up -d
```

### Frontend
```bash
cd frontend
docker compose up -d
```

## Pipeline CI/CD

Cada servicio tiene su workflow en `.github/workflows/`. El pipeline se activa con push en la rama `deploy` y ejecuta:

1. **Build** → construye la imagen Docker
2. **Push** → sube la imagen a Amazon ECR (registro privado de AWS)
3. **Deploy** → despliega en la EC2 correspondiente

### Repositorios ECR requeridos

Crear los siguientes repositorios en Amazon ECR (privados) antes de ejecutar los workflows:

| Repositorio | Imagen |
|-------------|--------|
| `innovatech-backend` | Backend Node.js |
| `innovatech-frontend` | Frontend Nginx |
| `innovatech-db` | Base de datos MySQL |

## Secrets requeridos en GitHub

| Secret | Descripción |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | Credencial AWS Academy |
| `AWS_SECRET_ACCESS_KEY` | Credencial AWS Academy |
| `AWS_SESSION_TOKEN` | Token de sesión AWS Academy |
| `AWS_REGION` | Región AWS (us-east-1) |
| `AWS_ACCOUNT_ID` | ID de cuenta AWS (12 dígitos) |

## Deploy manual en EC2

Tras cada push, la imagen queda disponible en ECR. Para desplegar en cada EC2 (vía Session Manager):

```bash
# 1. Autenticarse en ECR
aws ecr get-login-password --region <AWS_REGION> | \
  docker login --username AWS --password-stdin \
  <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com

# 2. Bajar la imagen
docker pull <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/innovatech-backend:latest

# 3. Reemplazar el contenedor
docker stop innovatech-backend || true
docker rm innovatech-backend || true
docker run -d \
  --name innovatech-backend \
  -p 3001:3001 \
  --env-file /home/ec2-user/backend/.env \
  <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/innovatech-backend:latest
```

> Reemplazar `innovatech-backend` por `innovatech-frontend` o `innovatech-db` según corresponda. El frontend no requiere `--env-file`.

## Persistencia de datos

La base de datos usa un **named volume** de Docker para que los datos no se pierdan al reiniciar el contenedor:

```yaml
volumes:
  innovatech-db-data:/var/lib/mysql
```

## Seguridad

- Solo el Frontend es accesible desde Internet (puerto 80)
- El Backend solo acepta tráfico desde el Security Group del Frontend (puerto 3001)
- La DB solo acepta tráfico desde el Security Group del Backend (puerto 3306)
- Las imágenes Docker se almacenan en un repositorio **privado** de Amazon ECR
