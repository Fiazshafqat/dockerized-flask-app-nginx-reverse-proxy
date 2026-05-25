# dockerized-flask-app-nginx-reverse-proxy
Dockerized Flask web application using multi-stage Docker builds, Docker Compose orchestration, and Nginx reverse proxy deployment.

# Flask Web Application with Docker Compose & Nginx Reverse Proxy

A complete hands-on DevOps project demonstrating how to deploy a Flask web application using Docker Compose, multi-stage Docker builds, and containerization, served through an Nginx reverse proxy on a local Ubuntu environment. This project helped strengthen practical understanding of Docker, container orchestration, reverse proxy architecture, and modern application deployment workflows. 🐳⚙️🌐

---

# 🚀 Project Architecture

```text
Browser/User
      │
      ▼
Nginx Reverse Proxy Container
      │
      ▼
Flask Web Application Container
```

---

# 📚 Technologies Used

| Component          | Technology               |
| ------------------ | ------------------------ |
| Backend Framework  | Flask                    |
| Runtime            | Python 3                 |
| Containerization   | Docker                   |
| Orchestration      | Docker Compose           |
| Reverse Proxy      | Nginx                    |
| OS Environment     | Ubuntu                   |
| Build Optimization | Multi-stage Docker Build |

---

# 📁 Project Structure

```text
flask-docker-nginx/
│
├── app.py
├── run.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── images/
    ├── Access Application.png.png
    └── Test Health.png.png
    ├── onatiners-running-status.png.png
    └── docker-compose-up-1.png.png
    ├── docker-compose-up-2.png.png
    └── docker-compose.png.png
    ├── dockerfile-multi-stage.png
    └── nginx-config-and-dockerfile.png

│
├── templates/
│   └── index.html
│
└── nginx/
    ├── Dockerfile
    └── default.conf
```

---

# ⚙️ Step 1 — Install Docker & Docker Compose

Update packages:

```bash
sudo apt update
```

Install Docker:

```bash
sudo apt install docker.io -y
```

Enable Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Verify installation:

```bash
docker --version
```

Install Docker Compose:

```bash
sudo apt install docker-compose-v2 -y
```

Verify:

```bash
docker compose version
```

---

# ⚙️ Step 2 — Create Project Directory and copy application code inside project directory

---

# ⚙️ Step 3 — Create Multi-Stage Dockerfile

## Dockerfile

```dockerfile
# -------------------------
# Stage 1: Builder Stage
# -------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# -------------------------
# Stage 2: Production Stage
# -------------------------
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install /usr/local

# Copy entire project correctly
COPY . .

# Expose Flask port
EXPOSE 80

# Run app
CMD ["python", "run.py"]

```

---

# ⚙️ Step 4 — Create Nginx Configuration

Create nginx directory:

```bash
mkdir nginx
cd nginx
```

---

## nginx/default.conf

```nginx
server {
    listen 80;

    server_name localhost;

    location / {
        proxy_pass http://flask-app:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

---

## nginx/Dockerfile

```# Base Images
FROM nginx:1.23.3-alpine

# Copy nginx default configuration file

COPY ./default.conf /etc/nginx/conf.d/default.conf

```

Return to project directory:

```bash
cd ..
```

---

# ⚙️ Step 5 — Create Docker Compose File

## docker-compose.yml

```version: "3.8"

services:

  flask-app:
    build: .
    container_name: flask-app
    ports:
      - "8000:80"
    networks:
      - flask-net
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:80 || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  nginx:
    build:
      context: ./ngnix
    container_name: nginx
    ports:
      - "80:80"
    restart: always
    depends_on:
      - flask-app
    networks:
      - flask-net
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

networks:
  flask-net:

```

---

# ⚙️ Step 6 — Build & Run Containers

Build and start services:

```bash
docker compose up --build -d
```

Check running containers:

```bash
docker ps
```

---

# 🌐 Step 7 — Access Application

## Access through Nginx Reverse Proxy

```text
http://localhost
```

or

```text
http://YOUR_SERVER_IP
```

---

# 🧪 Step 8 — Test Health Endpoint

```bash
curl http://localhost/health
```

Expected Output:

```text
Server is up and running
```

---

# 📦 Docker Concepts Used

## 🐳 Docker Containerization

The Flask application and Nginx server both run inside isolated Docker containers.

---

## ⚙️ Multi-Stage Docker Build

Used to optimize image size and separate dependency installation from the production image.

### Benefits:

* Smaller image size
* Better security
* Faster deployments
* Cleaner production environment

---

## 🔁 Docker Compose

Docker Compose was used to:

* Manage multiple containers
* Create networking automatically
* Simplify deployment commands
* Handle service dependencies

---

## 🌐 Nginx Reverse Proxy

Nginx sits in front of the Flask application and forwards incoming requests to the backend container.

### Benefits:

* Better security
* SSL/TLS support
* Load balancing capability
* Improved scalability

---

# 📂 Useful Docker Commands

## View Containers

```bash
docker ps
```

---

## View Logs

```bash
docker logs flask-app
docker logs nginx
```

---

## Stop Containers

```bash
docker compose down
```

---

## Rebuild Containers

```bash
docker compose up --build -d
```

---

# 🎯 Key Takeaways

* Learned practical Docker containerization
* Built optimized images using multi-stage builds
* Implemented container orchestration using Docker Compose
* Configured Nginx as a reverse proxy
* Understood container networking and communication
* Improved understanding of modern DevOps deployment workflows

---

# 🚀 Future Improvements

* Add HTTPS with SSL/TLS
* Deploy on AWS EC2
* Add CI/CD pipeline
* Integrate database container
* Implement load balancing
* Deploy with Kubernetes

---

# Project Screenshots

## 1. Access application in browser


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/Access%20Application.png.png?raw=true])


## 2. Test Health 


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/Test%20Health.png.png?raw=true])


## 3. Both Containers running status (nginx & Flask-app)


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/conatiners-running-status.png.png?raw=true])


## 4. Docker-compose file


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/docker-compose.png.png?raw=true])


## 5. Run docker-compose.yml file


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/docker-compose-up-1.png.png?raw=true])


## 6. Docker compose executed successfully 


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/cd669f8f4083ee5a08a775b98fa843a17ca58223/images/docker-compose-up-2.png.png?raw=true])

## 7. Multi Stage Dockerfile build 


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/748b7493837ee2e453a5ab9f93ff099c8cd72819/images/dockerfile-multi-stage.png?raw=true])

## 8. Nginx Dockerfile and nginx default.conf to work as reverse proxy 


![image alt](https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy/blob/748b7493837ee2e453a5ab9f93ff099c8cd72819/images/nginx-config-and-dockerfile.png?raw=true])



# 🏷️ Tags

`Docker` `Docker Compose` `Flask` `Python` `Nginx` `Reverse Proxy` `DevOps` `Containerization` `Ubuntu` `Linux` `Multi-Stage Builds`
