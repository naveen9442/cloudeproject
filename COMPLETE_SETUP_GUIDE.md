# Complete Setup Guide & Quick Start

## 📦 Step-by-Step Setup

### Step 1: Create GitHub Repository

```bash
# Create a new repository on GitHub
# Go to https://github.com/new
# Name: fullstack-app
# Description: Full Stack Application with Node.js, Angular, MongoDB
# Initialize with: .gitignore (Node)

# Clone the repository
git clone https://github.com/your-username/fullstack-app.git
cd fullstack-app
```

### Step 2: Create Project Structure

```bash
# Create directories
mkdir -p backend/src/{config,controllers,models,routes,middleware}
mkdir -p frontend/src/{app/{components,services},assets}
mkdir -p deploy

# Create necessary files from the package
# Copy all the files provided in this guide
```

### Step 3: Backend Setup

```bash
cd backend

# Create package.json (use content provided)
# Create all source files from the guide:
#   - src/server.js
#   - src/app.js
#   - src/config/database.js
#   - src/models/Product.js
#   - src/controllers/productController.js
#   - src/routes/productRoutes.js
#   - src/middleware/errorHandler.js
#   - .env.example
#   - Dockerfile

# Initialize
npm install

# Create .env file
cp .env.example .env

cd ..
```

### Step 4: Frontend Setup

```bash
cd frontend

# Create package.json (use content provided)
# Create all Angular files from the guide:
#   - src/main.ts
#   - src/app/app.module.ts
#   - src/app/app-routing.module.ts
#   - src/app/app.component.ts
#   - src/app/app.component.html
#   - src/app/services/product.service.ts
#   - src/app/components/product-list/*
#   - src/app/components/product-create/*
#   - src/app/components/product-update/*
#   - src/app/components/product-detail/*
#   - tsconfig.json
#   - Dockerfile
#   - nginx.conf

# Initialize
npm install

cd ..
```

### Step 5: Root Level Files

```bash
# Copy these to root directory:
#   - docker-compose.yml
#   - Jenkinsfile
#   - .gitignore
#   - README.md

# Copy deployment scripts
cp deploy/deploy-local.sh .
cp deploy/deploy-aws.sh deploy/
cp deploy/setup-server.sh deploy/
```

### Step 6: Git Initial Commit

```bash
# Stage all files
git add .

# Create initial commit
git commit -m "Initial commit: Full stack application setup"

# Push to GitHub
git push -u origin main
```

## 🚀 Running the Application

### Option 1: Local Development (Recommended)

```bash
# Make scripts executable
chmod +x deploy-local.sh
chmod +x deploy/deploy-aws.sh
chmod +x deploy/setup-server.sh

# Start the application
./deploy-local.sh

# Wait for 20-30 seconds for services to start
# Then open: http://localhost:4200
```

### Option 2: Manual Docker Compose

```bash
# Build all images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Option 3: Development Mode (Code Changes)

```bash
# Backend development
cd backend
npm install
npm run dev

# In another terminal - Frontend development
cd frontend
npm install
npm start
```

## 🔧 Configuration

### Backend Configuration (.env)

Create `backend/.env`:
```
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://mongodb:27017/fullstack_app
CORS_ORIGIN=http://localhost:4200
JWT_SECRET=your_jwt_secret_key_here
LOG_LEVEL=info
```

### Docker Compose Environment

For production (`docker-compose.yml`):
```
MONGO_PASSWORD=your_secure_password
JWT_SECRET=your_jwt_secret
FRONTEND_URL=https://yourdomain.com
```

## 🧪 Testing the Application

### Test Backend Health

```bash
# Check if backend is running
curl http://localhost:3000/api/health

# Expected response:
# {
#   "status": "OK",
#   "timestamp": "2024-01-01T00:00:00.000Z",
#   "uptime": 123.45
# }
```

### Test Create Product

```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "This is a test product",
    "price": 99.99,
    "category": "Electronics",
    "stock": 5
  }'
```

### Test Get Products

```bash
curl http://localhost:3000/api/products

# With pagination
curl "http://localhost:3000/api/products?page=1&limit=10"

# With category filter
curl "http://localhost:3000/api/products?category=Electronics"

# With search
curl "http://localhost:3000/api/products?search=laptop"
```

### Access Frontend

```
http://localhost:4200
```

You should see a working product management application!

## 📱 Frontend Testing

1. **List Products**: Navigate to /products, see all products
2. **Create Product**: Click "Add Product", fill form, submit
3. **View Details**: Click "View" on any product
4. **Edit Product**: Click "Edit", modify, save
5. **Delete Product**: Click "Delete", confirm
6. **Search**: Use search box to find products
7. **Filter**: Use category dropdown to filter
8. **Pagination**: Navigate between pages

## 🔐 Security Setup

### Before Production

1. **Update MongoDB Password**
   ```bash
   # In docker-compose.yml, change default password
   MONGO_INITDB_ROOT_PASSWORD: change_this_to_secure_password
   ```

2. **Update JWT Secret**
   ```bash
   # In .env files
   JWT_SECRET: generate_a_long_random_string
   ```

3. **Update CORS Origin**
   ```bash
   # Match your actual domain
   CORS_ORIGIN=https://yourdomain.com
   ```

4. **Environment Specific**
   ```bash
   NODE_ENV=production
   ```

## 🌐 AWS Deployment

### Prerequisites

- AWS Account
- EC2 instance (Ubuntu 20.04 or 22.04)
- Security group allowing ports: 22, 80, 443, 3000
- Domain name (optional but recommended)
- Docker Hub account

### Deployment Steps

```bash
# 1. SSH into your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-public-ip

# 2. Run server setup script
curl -sSL https://raw.githubusercontent.com/your-username/fullstack-app/main/deploy/setup-server.sh | bash

# 3. Configure environment
sudo nano /opt/fullstack-app/.env
# Update: MONGO_PASSWORD, JWT_SECRET, FRONTEND_URL

# 4. Deploy application
cd /opt/fullstack-app
chmod +x deploy/deploy-aws.sh
./deploy/deploy-aws.sh backend-image frontend-image

# 5. Check services
docker-compose ps
docker-compose logs -f
```

## 🔄 Git Workflow

### Creating a Feature

```bash
# Create feature branch
git checkout -b feature/user-authentication

# Make changes
# ... edit files ...

# Commit changes
git add .
git commit -m "feat: add user authentication"

# Push to GitHub
git push origin feature/user-authentication

# Create Pull Request on GitHub
# After review, merge to main
# Jenkins will automatically deploy
```

### Commit Message Convention

```
feat: add new feature
fix: fix a bug
docs: documentation changes
style: code style changes
refactor: refactor code
test: add tests
chore: maintenance tasks
```

## 📊 Monitoring & Logs

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb

# Last N lines
docker-compose logs --tail=50 backend

# Follow logs in real-time
docker-compose logs -f
```

### Check Service Status

```bash
# List all services
docker-compose ps

# View resource usage
docker stats

# Inspect a container
docker inspect fullstack-backend
```

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check logs
docker-compose logs

# Rebuild images
docker-compose build --no-cache

# Remove everything and start fresh
docker-compose down -v
docker-compose up -d
```

### Port Already in Use

```bash
# Find process using the port
lsof -i :3000
lsof -i :4200
lsof -i :27017

# Kill the process
kill -9 <PID>
```

### MongoDB Connection Issues

```bash
# Check if MongoDB is healthy
docker-compose logs mongodb

# Restart MongoDB
docker-compose restart mongodb

# Check connection string in backend logs
docker-compose logs backend | grep -i mongodb
```

### Frontend Not Loading

```bash
# Check nginx/frontend logs
docker-compose logs frontend

# Check if nginx is serving files
docker-compose exec frontend ls -la /usr/share/nginx/html/

# Rebuild frontend
docker-compose up --build frontend
```

## 📚 File Structure Overview

```
fullstack-app/
├── backend/
│   ├── src/
│   │   ├── config/database.js       (MongoDB connection)
│   │   ├── models/Product.js        (MongoDB schema)
│   │   ├── controllers/             (Business logic)
│   │   ├── routes/                  (API endpoints)
│   │   ├── middleware/              (Error handling)
│   │   ├── app.js                   (Express config)
│   │   └── server.js                (Entry point)
│   ├── package.json
│   ├── .env.example
│   ├── .gitignore
│   └── Dockerfile
│
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/          (Angular components)
│   │   │   ├── services/            (API services)
│   │   │   ├── app.module.ts
│   │   │   └── app-routing.module.ts
│   │   └── main.ts
│   ├── package.json
│   ├── tsconfig.json
│   ├── .gitignore
│   ├── Dockerfile
│   └── nginx.conf
│
├── deploy/
│   ├── deploy-aws.sh                (AWS deployment)
│   ├── deploy-local.sh              (Local deployment)
│   └── setup-server.sh              (Server setup)
│
├── docker-compose.yml               (Local dev setup)
├── Jenkinsfile                      (CI/CD pipeline)
├── .gitignore
└── README.md
```

## ✅ Deployment Checklist

- [ ] Backend code complete with error handling
- [ ] Frontend code complete with all components
- [ ] Docker files created and tested
- [ ] docker-compose.yml configured
- [ ] Jenkinsfile created and updated with credentials
- [ ] Environment files (.env.example) created
- [ ] .gitignore files in place
- [ ] README and documentation complete
- [ ] Deployment scripts tested
- [ ] Git repository initialized and pushed
- [ ] Jenkins pipeline configured
- [ ] AWS EC2 instance ready (if using AWS)
- [ ] MongoDB backup strategy planned
- [ ] SSL certificate prepared (for production)
- [ ] Domain DNS configured (if applicable)

## 🎉 Success!

Your full stack application is now ready:
- ✅ Local development with Docker Compose
- ✅ Git version control and GitHub
- ✅ Jenkins CI/CD pipeline
- ✅ Automated deployment to AWS or local server
- ✅ Production-ready code
- ✅ Complete documentation

**Next Steps:**
1. Push code to GitHub
2. Set up Jenkins pipeline
3. Deploy to your server
4. Monitor and maintain

Happy coding! 🚀
