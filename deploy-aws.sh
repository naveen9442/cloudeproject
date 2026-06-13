#!/bin/bash

# AWS Deployment Script
# Usage: ./deploy-aws.sh <backend-image> <frontend-image>

set -e

BACKEND_IMAGE=${1:-"docker.io/your-username/fullstack-app:backend-latest"}
FRONTEND_IMAGE=${2:-"docker.io/your-username/fullstack-app:frontend-latest"}

echo "=========================================="
echo "Starting AWS Deployment"
echo "=========================================="
echo "Backend Image: $BACKEND_IMAGE"
echo "Frontend Image: $FRONTEND_IMAGE"

# Configuration
APP_NAME="fullstack-app"
APP_DIR="/opt/fullstack-app"
DATA_DIR="$APP_DIR/data"
BACKUP_DIR="/opt/backups"

# Create necessary directories
mkdir -p $APP_DIR
mkdir -p $DATA_DIR
mkdir -p $BACKUP_DIR

# Backup current docker-compose if exists
if [ -f "$APP_DIR/docker-compose.yml" ]; then
    echo "Backing up current configuration..."
    cp "$APP_DIR/docker-compose.yml" "$BACKUP_DIR/docker-compose-$(date +%s).yml"
fi

# Create docker-compose.prod.yml
cat > "$APP_DIR/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  mongodb:
    image: mongo:latest
    container_name: fullstack-mongodb-prod
    restart: always
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      MONGO_INITDB_DATABASE: fullstack_app
    volumes:
      - mongo_data:/data/db
      - mongo_config:/data/configdb
    networks:
      - fullstack-network
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    image: BACKEND_IMAGE_PLACEHOLDER
    container_name: fullstack-backend-prod
    restart: always
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      PORT: 3000
      MONGODB_URI: mongodb://admin:${MONGO_PASSWORD}@mongodb:27017/fullstack_app?authSource=admin
      CORS_ORIGIN: ${FRONTEND_URL}
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      mongodb:
        condition: service_healthy
    networks:
      - fullstack-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  frontend:
    image: FRONTEND_IMAGE_PLACEHOLDER
    container_name: fullstack-frontend-prod
    restart: always
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - backend
    networks:
      - fullstack-network
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/index.html"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

networks:
  fullstack-network:
    driver: bridge

volumes:
  mongo_data:
  mongo_config:
EOF

# Replace image placeholders
sed -i "s|BACKEND_IMAGE_PLACEHOLDER|$BACKEND_IMAGE|g" "$APP_DIR/docker-compose.yml"
sed -i "s|FRONTEND_IMAGE_PLACEHOLDER|$FRONTEND_IMAGE|g" "$APP_DIR/docker-compose.yml"

# Create .env file if doesn't exist
if [ ! -f "$APP_DIR/.env" ]; then
    echo "Creating .env file..."
    cat > "$APP_DIR/.env" << 'ENVFILE'
NODE_ENV=production
MONGO_PASSWORD=your_secure_password_here
JWT_SECRET=your_jwt_secret_here
FRONTEND_URL=https://yourdomain.com
ENVFILE
    echo "⚠️  WARNING: Update the .env file with your actual values!"
fi

# Stop existing containers
echo "Stopping existing containers..."
cd $APP_DIR
docker-compose down || true

# Pull latest images
echo "Pulling latest images..."
docker pull $BACKEND_IMAGE
docker pull $FRONTEND_IMAGE

# Start containers
echo "Starting containers..."
docker-compose up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 15

# Check health
echo "Checking service health..."
docker-compose ps

# Check backend health
if curl -f http://localhost:3000/api/health; then
    echo "✓ Backend is healthy"
else
    echo "✗ Backend health check failed"
    exit 1
fi

# Check frontend health
if curl -f http://localhost || curl -f http://localhost/index.html; then
    echo "✓ Frontend is healthy"
else
    echo "✗ Frontend health check failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "✓ Deployment completed successfully!"
echo "=========================================="
echo "Frontend: http://localhost"
echo "Backend: http://localhost:3000"
echo "MongoDB: localhost:27017"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop services: docker-compose down"
