#!/bin/bash

# Local Server Deployment Script
# Usage: ./deploy-local.sh

set -e

echo "=========================================="
echo "Starting Local Deployment"
echo "=========================================="

# Check if Docker and Docker Compose are installed
echo "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "✗ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
    echo "✗ Docker Compose is not installed."
    exit 1
fi

echo "✓ Docker and Docker Compose are installed"

# Configuration
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if docker-compose.yml exists
if [ ! -f "$APP_DIR/docker-compose.yml" ]; then
    echo "✗ docker-compose.yml not found in $APP_DIR"
    exit 1
fi

# Stop existing containers
echo "Stopping existing containers..."
cd $APP_DIR
docker compose down || true

# Check if images need to be rebuilt
echo "Building Docker images..."
docker compose build --no-cache

# Start containers
echo "Starting containers..."
docker compose up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 20

# Check health
echo "Checking service health..."
docker compose ps

# Display service information
echo ""
echo "=========================================="
echo "✓ Deployment completed successfully!"
echo "=========================================="
echo ""
echo "Services are running:"
echo "  • Frontend: http://localhost:4200"
echo "  • Backend API: http://localhost:3000"
echo "  • MongoDB: localhost:27017"
echo ""
echo "Database credentials:"
echo "  • Username: admin"
echo "  • Password: password123"
echo ""
echo "Useful commands:"
echo "  View logs:     docker compose logs -f"
echo "  View services: docker compose ps"
echo "  Stop services: docker compose down"
echo "  Remove data:   docker compose down -v"
echo ""

# Try to open in browser
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:4200
elif command -v open &> /dev/null; then
    open http://localhost:4200
fi

echo "=========================================="
