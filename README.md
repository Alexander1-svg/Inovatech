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

## Variables de entorno

### backend/.env
```env
PORT=3001
DB_HOST=<IP_PRIVADA_EC2_DB>
DB_USER=alumno
DB_PASSWORD=alumno123
DB_NAME=innovatech
DB_PORT=3306
```

### db/.env
```env
MYSQL_ROOT_PASSWORD=admin123
MYSQL_DATABASE=innovatech
MYSQL_USER=alumno
MYSQL_PASSWORD=alumno123
```

## Pipeline CI/CD

Cada repositorio tiene su workflow en `.github/workflows/`. El pipeline se activa con push en la rama `deploy` y ejecuta:

1. **Build** → construye la imagen Docker
2. **Push** → sube la imagen a Docker Hub
3. **Deploy** → despliega en la EC2 correspondiente vía SSM

## Secrets requeridos en GitHub

| Secret | Descripción |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Usuario de Docker Hub |
| `DOCKERHUB_TOKEN` | Token de acceso Docker Hub |
| `AWS_ACCESS_KEY_ID` | Credencial AWS Academy |
| `AWS_SECRET_ACCESS_KEY` | Credencial AWS Academy |
| `AWS_SESSION_TOKEN` | Token de sesión AWS Academy |
| `AWS_REGION` | Región AWS (us-east-1) |
| `EC2_BACKEND_INSTANCE_ID` | ID instancia EC2 Backend |
| `EC2_FRONTEND_INSTANCE_ID` | ID instancia EC2 Frontend |
| `EC2_DB_INSTANCE_ID` | ID instancia EC2 DB |

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
