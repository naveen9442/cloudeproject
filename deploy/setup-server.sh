#!/bin/bash

# AWS EC2 Server Setup Script
# Run this on a fresh Ubuntu 20.04/22.04 EC2 instance
# Usage: curl -sSL https://your-repo/setup-server.sh | bash

set -e

echo "=========================================="
echo "Setting up AWS Server"
echo "=========================================="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Update system packages
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install Docker
echo "Installing Docker..."
apt-get install -y docker.io docker-compose

# Add current user to docker group
usermod -aG docker $(whoami) || echo "User already in docker group"

# Start Docker service
systemctl start docker
systemctl enable docker

# Install additional tools
echo "Installing additional tools..."
apt-get install -y git curl wget nodejs npm

# Create app directory
APP_DIR="/opt/fullstack-app"
mkdir -p $APP_DIR
cd $APP_DIR

# Clone repository (replace with your repo)
echo "Cloning repository..."
git clone https://github.com/your-username/fullstack-app.git .

# Copy nginx config if exists
if [ -f "frontend/nginx.conf" ]; then
    cp frontend/nginx.conf /etc/nginx/
    systemctl reload nginx 2>/dev/null || true
fi

# Create data directories
mkdir -p data/mongodb

# Create firewall rules
echo "Configuring firewall..."
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 3000/tcp  # Backend API (optional, restrict if needed)

echo ""
echo "=========================================="
echo "✓ Server setup completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Configure environment variables:"
echo "   Edit: $APP_DIR/.env"
echo ""
echo "2. Deploy the application:"
echo "   cd $APP_DIR"
echo "   bash deploy/deploy-aws.sh"
echo ""
echo "3. Set up SSL certificate (recommended):"
echo "   sudo apt-get install certbot python3-certbot-nginx"
echo "   sudo certbot certonly --standalone -d yourdomain.com"
echo ""
echo "=========================================="
