<!--
MIT License

Copyright (c) 2025 S&H Tech Labs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->

# Deployment Guide

## S&H Tech Labs – AI Dental Health Platform

### Overview

This guide provides comprehensive instructions for deploying the S&H Tech Labs AI Dental Health Platform across different environments, from development to production. The platform uses a cloud-native, containerized architecture designed for scalability and reliability.

### Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Local Development Deployment](#local-development-deployment)
4. [Staging Environment](#staging-environment)
5. [Production Deployment](#production-deployment)
6. [Database Management](#database-management)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Security Configuration](#security-configuration)
9. [Backup and Recovery](#backup-and-recovery)
10. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Tools and Services

#### Local Development
- **Docker Desktop**: Version 20.10.x or higher
- **Docker Compose**: Version 2.x or higher
- **Node.js**: Version 18.x or higher
- **Git**: Latest version

#### Cloud Infrastructure
- **AWS Account**: With appropriate IAM permissions
- **Domain Name**: For production deployment
- **SSL Certificate**: For HTTPS encryption
- **Container Registry**: AWS ECR, Docker Hub, or equivalent

#### Third-Party Services
- **Email Service**: AWS SES, SendGrid, or similar
- **SMS Service**: Twilio, AWS SNS, or equivalent
- **CDN**: CloudFlare, AWS CloudFront, or similar
- **Monitoring**: Datadog, New Relic, or similar

### Infrastructure Requirements

#### Development Environment
- **CPU**: 4 cores minimum
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 50GB available space
- **Network**: Stable internet connection

#### Production Environment
- **Application Servers**: 3x t3.large instances minimum
- **Database**: RDS PostgreSQL db.t3.medium with Multi-AZ
- **Cache**: ElastiCache Redis cluster
- **Load Balancer**: Application Load Balancer
- **Storage**: S3 bucket with appropriate permissions

---

## Environment Setup

### Environment Variables Configuration

#### Core Application Variables
```bash
# .env.production
NODE_ENV=production
PORT=3000
API_VERSION=v1

# Database Configuration
DATABASE_URL=postgresql://user:password@host:5432/database
REDIS_URL=redis://redis-cluster:6379
MONGODB_URL=mongodb://mongodb-cluster:27017/shtechlabs

# Authentication
JWT_SECRET=your-super-secure-jwt-secret-key
JWT_EXPIRATION=24h
REFRESH_TOKEN_EXPIRATION=7d

# AI Service Configuration
AI_SERVICE_URL=http://ai-service:5000
AI_MODEL_VERSION=v2.1.0

# File Storage
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
S3_BUCKET_NAME=shtechlabs-files
S3_REGION=us-east-1

# Email Configuration
SMTP_HOST=smtp.amazonaws.com
SMTP_PORT=587
SMTP_USER=your-smtp-user
SMTP_PASS=your-smtp-password
FROM_EMAIL=noreply@shtechlabs.com

# Monitoring and Logging
LOG_LEVEL=info
SENTRY_DSN=your-sentry-dsn
DATADOG_API_KEY=your-datadog-key

# Security
CORS_ORIGIN=https://app.shtechlabs.com
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100
ENCRYPTION_KEY=your-encryption-key
```

#### AI Service Variables
```bash
# .env.ai-service
FLASK_ENV=production
MODEL_PATH=/app/models
TEMP_UPLOAD_PATH=/tmp/uploads
MAX_FILE_SIZE=50MB
SUPPORTED_FORMATS=jpg,jpeg,png,dicom

# ML Model Configuration
CAVITY_MODEL_PATH=/app/models/cavity_detection_v2.h5
GUM_DISEASE_MODEL_PATH=/app/models/gum_analysis_v1.h5
CONFIDENCE_THRESHOLD=0.8

# Performance
WORKERS=4
THREADS=2
TIMEOUT=300
```

---

## Local Development Deployment

### Docker Compose Setup

#### Core Services Configuration
```yaml
# docker-compose.yml
version: '3.8'

services:
  # Frontend Application
  frontend:
    build: 
      context: ./frontend
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - REACT_APP_API_URL=http://localhost:4000/api/v1
    depends_on:
      - backend

  # Backend API Service
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:password@postgres:5432/shtechlabs_dev
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
      - ai-service

  # AI Service
  ai-service:
    build:
      context: ./ai-service
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    volumes:
      - ./ai-service:/app
      - ./models:/app/models
    environment:
      - FLASK_ENV=development
      - MODEL_PATH=/app/models

  # PostgreSQL Database
  postgres:
    image: postgres:13-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=shtechlabs_dev
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  # MongoDB (for analytics and logs)
  mongodb:
    image: mongo:6-focal
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
      - MONGO_INITDB_DATABASE=shtechlabs
    volumes:
      - mongodb_data:/data/db

  # NGINX Reverse Proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/dev.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - frontend
      - backend

volumes:
  postgres_data:
  redis_data:
  mongodb_data:
```

#### Development Commands
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild services after code changes
docker-compose up --build

# Access service shells
docker-compose exec backend bash
docker-compose exec ai-service bash

# Database operations
docker-compose exec postgres psql -U postgres -d shtechlabs_dev
```

---

## Staging Environment

### Infrastructure Setup

#### AWS ECS Configuration
```yaml
# ecs-staging.yml
version: '3'
services:
  frontend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/shtechlabs-frontend:${IMAGE_TAG}
    ports:
      - "80:80"
    environment:
      - REACT_APP_API_URL=https://api-staging.shtechlabs.com/api/v1
    logging:
      driver: awslogs
      options:
        awslogs-group: /ecs/shtechlabs-staging
        awslogs-region: ${AWS_REGION}

  backend:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/shtechlabs-backend:${IMAGE_TAG}
    ports:
      - "4000:4000"
    environment:
      - NODE_ENV=staging
      - DATABASE_URL=${STAGING_DATABASE_URL}
      - REDIS_URL=${STAGING_REDIS_URL}
    secrets:
      - jwt_secret
      - database_password
    logging:
      driver: awslogs
      options:
        awslogs-group: /ecs/shtechlabs-staging
        awslogs-region: ${AWS_REGION}

  ai-service:
    image: ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/shtechlabs-ai:${IMAGE_TAG}
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=staging
    logging:
      driver: awslogs
      options:
        awslogs-group: /ecs/shtechlabs-staging
        awslogs-region: ${AWS_REGION}

secrets:
  jwt_secret:
    external: true
  database_password:
    external: true
```

#### Deployment Script
```bash
#!/bin/bash
# deploy-staging.sh

set -e

# Configuration
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="123456789012"
ECR_REPOSITORY="shtechlabs"
IMAGE_TAG="staging-$(date +%Y%m%d-%H%M%S)"
ECS_CLUSTER="shtechlabs-staging"
ECS_SERVICE="shtechlabs-staging-service"

# Build and push images
echo "Building and pushing Docker images..."

# Frontend
docker build -t ${ECR_REPOSITORY}-frontend:${IMAGE_TAG} ./frontend
docker tag ${ECR_REPOSITORY}-frontend:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-frontend:${IMAGE_TAG}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-frontend:${IMAGE_TAG}

# Backend
docker build -t ${ECR_REPOSITORY}-backend:${IMAGE_TAG} ./backend
docker tag ${ECR_REPOSITORY}-backend:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-backend:${IMAGE_TAG}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-backend:${IMAGE_TAG}

# AI Service
docker build -t ${ECR_REPOSITORY}-ai:${IMAGE_TAG} ./ai-service
docker tag ${ECR_REPOSITORY}-ai:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-ai:${IMAGE_TAG}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}-ai:${IMAGE_TAG}

# Update ECS service
echo "Updating ECS service..."
aws ecs update-service \
  --cluster ${ECS_CLUSTER} \
  --service ${ECS_SERVICE} \
  --force-new-deployment

# Wait for deployment to complete
echo "Waiting for deployment to complete..."
aws ecs wait services-stable \
  --cluster ${ECS_CLUSTER} \
  --services ${ECS_SERVICE}

echo "Staging deployment completed successfully!"
```

---

## Production Deployment

### Kubernetes Configuration

#### Namespace and ConfigMap
```yaml
# k8s/namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: shtechlabs-prod

---
# k8s/configmap.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: shtechlabs-prod
data:
  NODE_ENV: "production"
  API_VERSION: "v1"
  LOG_LEVEL: "info"
  CORS_ORIGIN: "https://app.shtechlabs.com"
```

#### Backend Deployment
```yaml
# k8s/backend-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: shtechlabs-prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: shtechlabs/backend:v1.2.0
        ports:
        - containerPort: 4000
        env:
        - name: NODE_ENV
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: NODE_ENV
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: jwt-secret
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 4000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 4000
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: shtechlabs-prod
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 4000
  type: ClusterIP
```

#### Frontend Deployment
```yaml
# k8s/frontend-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: shtechlabs-prod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: shtechlabs/frontend:v1.2.0
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: shtechlabs-prod
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

#### Ingress Configuration
```yaml
# k8s/ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: shtechlabs-ingress
  namespace: shtechlabs-prod
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  tls:
  - hosts:
    - app.shtechlabs.com
    - api.shtechlabs.com
    secretName: shtechlabs-tls
  rules:
  - host: app.shtechlabs.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  - host: api.shtechlabs.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
```

#### Deployment Script
```bash
#!/bin/bash
# deploy-production.sh

set -e

# Configuration
NAMESPACE="shtechlabs-prod"
IMAGE_TAG="v1.2.0"

# Validate environment
echo "Validating production environment..."
kubectl cluster-info
kubectl get nodes

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secrets.yml
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/frontend-deployment.yml
kubectl apply -f k8s/ai-service-deployment.yml
kubectl apply -f k8s/ingress.yml

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/backend -n ${NAMESPACE}
kubectl rollout status deployment/frontend -n ${NAMESPACE}
kubectl rollout status deployment/ai-service -n ${NAMESPACE}

# Verify deployment
echo "Verifying deployment..."
kubectl get pods -n ${NAMESPACE}
kubectl get services -n ${NAMESPACE}
kubectl get ingress -n ${NAMESPACE}

# Run health checks
echo "Running health checks..."
curl -f https://api.shtechlabs.com/health || exit 1
curl -f https://app.shtechlabs.com/ || exit 1

echo "Production deployment completed successfully!"
```

---

## Database Management

### Database Migrations

#### Migration Script
```bash
#!/bin/bash
# migrate-database.sh

set -e

ENVIRONMENT=${1:-development}
DB_URL=${DATABASE_URL}

echo "Running database migrations for ${ENVIRONMENT} environment..."

# Run migrations
npx knex migrate:latest --env ${ENVIRONMENT}

# Run seeds (only for development/staging)
if [ "$ENVIRONMENT" != "production" ]; then
    npx knex seed:run --env ${ENVIRONMENT}
fi

echo "Database migration completed!"
```

#### Backup and Restore
```bash
#!/bin/bash
# backup-database.sh

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
DB_NAME="shtechlabs_prod"

# Create backup
pg_dump ${DATABASE_URL} > ${BACKUP_DIR}/backup_${TIMESTAMP}.sql

# Compress backup
gzip ${BACKUP_DIR}/backup_${TIMESTAMP}.sql

# Upload to S3
aws s3 cp ${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz s3://shtechlabs-backups/database/

# Clean up old local backups (keep last 7 days)
find ${BACKUP_DIR} -name "backup_*.sql.gz" -mtime +7 -delete

echo "Database backup completed: backup_${TIMESTAMP}.sql.gz"
```

### Data Seeding

#### Development Seeds
```javascript
// seeds/01_users.js
exports.seed = async function(knex) {
  // Clear existing entries
  await knex('users').del();
  
  // Insert seed data
  await knex('users').insert([
    {
      id: '550e8400-e29b-41d4-a716-446655440001',
      email: 'admin@shtechlabs.com',
      firstName: 'Admin',
      lastName: 'User',
      role: 'admin',
      password: '$2b$10$...' // hashed password
    },
    {
      id: '550e8400-e29b-41d4-a716-446655440002',
      email: 'dentist@shtechlabs.com',
      firstName: 'Dr. John',
      lastName: 'Smith',
      role: 'dentist',
      password: '$2b$10$...' // hashed password
    }
  ]);
};
```

---

## Monitoring and Logging

### Application Monitoring

#### Prometheus Configuration
```yaml
# monitoring/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

scrape_configs:
  - job_name: 'shtechlabs-backend'
    static_configs:
      - targets: ['backend-service:4000']
    metrics_path: '/metrics'
    scrape_interval: 10s

  - job_name: 'shtechlabs-ai'
    static_configs:
      - targets: ['ai-service:5000']
    metrics_path: '/metrics'
    scrape_interval: 10s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

#### Grafana Dashboard
```yaml
# monitoring/grafana-dashboard.json
{
  "dashboard": {
    "title": "S&H Tech Labs - Production Monitoring",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "label": "Requests/sec"
          }
        ]
      },
      {
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "label": "95th percentile"
          }
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])",
            "label": "5xx errors/sec"
          }
        ]
      }
    ]
  }
}
```

### Logging Configuration

#### ELK Stack Setup
```yaml
# logging/elasticsearch.yml
version: '3.7'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.5.0
    environment:
      - node.name=es01
      - cluster.name=shtechlabs-logs
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"

  logstash:
    image: docker.elastic.co/logstash/logstash:8.5.0
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    ports:
      - "5044:5044"
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.5.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch

volumes:
  elasticsearch_data:
```

---

## Security Configuration

### SSL/TLS Configuration

#### NGINX SSL Configuration
```nginx
# nginx/ssl.conf
server {
    listen 443 ssl http2;
    server_name app.shtechlabs.com;

    ssl_certificate /etc/ssl/certs/shtechlabs.crt;
    ssl_certificate_key /etc/ssl/private/shtechlabs.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    ssl_session_timeout 10m;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    # Security headers
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        proxy_pass http://frontend-service;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Security Scanning

#### Container Security Scan
```bash
#!/bin/bash
# security-scan.sh

set -e

IMAGES=("shtechlabs/frontend:latest" "shtechlabs/backend:latest" "shtechlabs/ai:latest")

echo "Running security scans on container images..."

for image in "${IMAGES[@]}"; do
    echo "Scanning $image..."
    
    # Trivy security scan
    trivy image --exit-code 1 --severity HIGH,CRITICAL $image
    
    # Hadolint Dockerfile lint
    hadolint $(dirname $0)/../$(echo $image | cut -d'/' -f2 | cut -d':' -f1)/Dockerfile
done

echo "Security scan completed!"
```

---

## Backup and Recovery

### Automated Backup Strategy

#### Backup Script
```bash
#!/bin/bash
# automated-backup.sh

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/shtechlabs"
S3_BUCKET="shtechlabs-backups"

# Create backup directory
mkdir -p ${BACKUP_DIR}

# Database backup
echo "Creating database backup..."
pg_dump ${DATABASE_URL} > ${BACKUP_DIR}/database_${TIMESTAMP}.sql

# Redis backup
echo "Creating Redis backup..."
redis-cli --rdb ${BACKUP_DIR}/redis_${TIMESTAMP}.rdb

# File storage backup
echo "Syncing file storage..."
aws s3 sync s3://shtechlabs-files ${BACKUP_DIR}/files_${TIMESTAMP}

# Compress backups
tar -czf ${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz ${BACKUP_DIR}/*_${TIMESTAMP}*

# Upload to S3
echo "Uploading backup to S3..."
aws s3 cp ${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz s3://${S3_BUCKET}/

# Clean up local files
rm -rf ${BACKUP_DIR}/*_${TIMESTAMP}*

# Clean up old backups (keep last 30 days)
aws s3 ls s3://${S3_BUCKET}/ | grep backup_ | sort | head -n -30 | awk '{print $4}' | xargs -I {} aws s3 rm s3://${S3_BUCKET}/{}

echo "Backup completed: backup_${TIMESTAMP}.tar.gz"
```

### Disaster Recovery Plan

#### Recovery Procedures
```bash
#!/bin/bash
# disaster-recovery.sh

set -e

BACKUP_FILE=${1}
RECOVERY_DATE=${2:-$(date +%Y%m%d_%H%M%S)}

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file> [recovery_date]"
    exit 1
fi

echo "Starting disaster recovery process..."
echo "Backup file: $BACKUP_FILE"
echo "Recovery date: $RECOVERY_DATE"

# Download backup from S3
echo "Downloading backup from S3..."
aws s3 cp s3://shtechlabs-backups/${BACKUP_FILE} /tmp/

# Extract backup
echo "Extracting backup..."
tar -xzf /tmp/${BACKUP_FILE} -C /tmp/

# Stop services
echo "Stopping services..."
kubectl scale deployment --replicas=0 --all -n shtechlabs-prod

# Restore database
echo "Restoring database..."
psql ${DATABASE_URL} < /tmp/database_*.sql

# Restore Redis
echo "Restoring Redis..."
redis-cli --pipe < /tmp/redis_*.rdb

# Restore files
echo "Restoring file storage..."
aws s3 sync /tmp/files_*/ s3://shtechlabs-files/

# Restart services
echo "Restarting services..."
kubectl scale deployment --replicas=3 backend -n shtechlabs-prod
kubectl scale deployment --replicas=2 frontend -n shtechlabs-prod
kubectl scale deployment --replicas=2 ai-service -n shtechlabs-prod

# Wait for services to be ready
echo "Waiting for services to be ready..."
kubectl rollout status deployment/backend -n shtechlabs-prod
kubectl rollout status deployment/frontend -n shtechlabs-prod
kubectl rollout status deployment/ai-service -n shtechlabs-prod

# Run health checks
echo "Running health checks..."
curl -f https://api.shtechlabs.com/health
curl -f https://app.shtechlabs.com/

echo "Disaster recovery completed successfully!"
```

---

## Troubleshooting

### Common Issues and Solutions

#### Application Not Starting
```bash
# Check logs
kubectl logs -l app=backend -n shtechlabs-prod
kubectl logs -l app=frontend -n shtechlabs-prod

# Check resource usage
kubectl top pods -n shtechlabs-prod

# Check service endpoints
kubectl get endpoints -n shtechlabs-prod

# Check ingress configuration
kubectl describe ingress shtechlabs-ingress -n shtechlabs-prod
```

#### Database Connection Issues
```bash
# Test database connectivity
kubectl run -it --rm debug --image=postgres:13 --restart=Never -- psql ${DATABASE_URL}

# Check database status
kubectl exec -it postgres-pod -- pg_isready

# View database logs
kubectl logs postgres-pod
```

#### Performance Issues
```bash
# Check resource usage
kubectl top nodes
kubectl top pods -n shtechlabs-prod

# Scale services
kubectl scale deployment backend --replicas=5 -n shtechlabs-prod

# Check metrics
curl http://prometheus:9090/api/v1/query?query=rate(http_requests_total[5m])
```

### Monitoring and Alerting

#### Health Check Endpoints
```javascript
// backend/src/routes/health.js
router.get('/health', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: process.env.npm_package_version,
    environment: process.env.NODE_ENV
  };

  // Check database connection
  try {
    await db.raw('SELECT 1');
    health.database = 'connected';
  } catch (error) {
    health.status = 'unhealthy';
    health.database = 'disconnected';
  }

  // Check Redis connection
  try {
    await redis.ping();
    health.redis = 'connected';
  } catch (error) {
    health.status = 'unhealthy';
    health.redis = 'disconnected';
  }

  const statusCode = health.status === 'healthy' ? 200 : 503;
  res.status(statusCode).json(health);
});
```

This deployment guide provides comprehensive instructions for deploying the S&H Tech Labs AI Dental Health Platform across all environments. For additional support and updates, please refer to the DevOps team documentation and monitoring dashboards.
