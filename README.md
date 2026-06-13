# Full Stack Application - Node.js + Angular + MongoDB

A complete, production-ready full stack application with Node.js backend, Angular frontend, MongoDB database, Docker containerization, and Jenkins CI/CD pipeline.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Development](#development)
- [Deployment](#deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Git Workflow](#git-workflow)
- [API Documentation](#api-documentation)
- [Troubleshooting](#troubleshooting)

## ✨ Features

### Backend (Node.js/Express)
- RESTful API with proper error handling
- MongoDB integration with Mongoose
- CORS support
- Request logging with Morgan
- Security headers with Helmet
- Input validation
- Health check endpoint
- Pagination support
- Search functionality

### Frontend (Angular)
- Responsive UI with Bootstrap
- Product CRUD operations
- Search and filtering
- Pagination
- Error handling
- Service-based architecture
- Type-safe with TypeScript
- Routing with lazy loading ready

### DevOps
- Docker containerization
- Docker Compose for local development
- Jenkins CI/CD pipeline
- Automated deployment scripts
- Health checks
- Easy AWS deployment

## 📁 Project Structure

```
my-fullstack-app/
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js
│   │   ├── controllers/
│   │   │   └── productController.js
│   │   ├── models/
│   │   │   └── Product.js
│   │   ├── routes/
│   │   │   └── productRoutes.js
│   │   ├── middleware/
│   │   │   └── errorHandler.js
│   │   ├── app.js
│   │   └── server.js
│   ├── .env.example
│   ├── Dockerfile
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/
│   │   │   ├── services/
│   │   │   └── app.module.ts
│   │   └── index.html
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
│
├── deploy/
│   ├── deploy-aws.sh
│   ├── deploy-local.sh
│   └── setup-server.sh
│
├── docker-compose.yml
├── Jenkinsfile
└── README.md
```

## 🔧 Prerequisites

### Local Development
- Node.js 18+
- Docker and Docker Compose
- Git
- VS Code or your preferred IDE

### AWS Deployment
- AWS account with EC2 instance (Ubuntu 20.04/22.04)
- SSH access to the server
- Docker Hub account (for image registry)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/fullstack-app.git
cd fullstack-app
```

### 2. Local Development (Docker Compose)

```bash
# Make deployment script executable
chmod +x deploy/deploy-local.sh

# Start all services
./deploy/deploy-local.sh
```

The application will be available at:
- **Frontend**: http://localhost:4200
- **Backend API**: http://localhost:3000
- **MongoDB**: localhost:27017

### 3. View Logs

```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
```

### 4. Stop Services

```bash
docker-compose down

# Remove volumes as well
docker-compose down -v
```

## 💻 Development

### Backend Development

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start development server with auto-reload
npm run dev

# Run tests
npm test
```

**Backend API Endpoints:**

- `GET /api/health` - Health check
- `GET /api/products` - Get all products (with pagination, filtering, search)
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product
- `GET /api/products/stats/overview` - Get statistics

**Environment Variables:**

```
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/fullstack_app
CORS_ORIGIN=http://localhost:4200
JWT_SECRET=your_jwt_secret_key_here
```

### Frontend Development

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build:prod

# Run tests
npm test
```

### API Request Examples

**Create Product:**
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Laptop",
    "description": "High performance laptop",
    "price": 999.99,
    "category": "Electronics",
    "stock": 10
  }'
```

**Get Products with Pagination:**
```bash
curl "http://localhost:3000/api/products?page=1&limit=10&category=Electronics"
```

**Search Products:**
```bash
curl "http://localhost:3000/api/products?search=laptop"
```

## 🌐 Deployment

### AWS EC2 Deployment

#### Step 1: Set Up EC2 Instance

```bash
# SSH into your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# Run the setup script
curl -sSL https://raw.githubusercontent.com/your-username/fullstack-app/main/deploy/setup-server.sh | bash
```

#### Step 2: Configure Environment

```bash
# Edit the .env file with your production values
sudo nano /opt/fullstack-app/.env

# Update these values:
MONGO_PASSWORD=your_secure_password
JWT_SECRET=your_jwt_secret
FRONTEND_URL=https://yourdomain.com
```

#### Step 3: Deploy Application

```bash
cd /opt/fullstack-app

# Make deploy script executable
chmod +x deploy/deploy-aws.sh

# Run deployment
./deploy/deploy-aws.sh
```

#### Step 4: Configure SSL with Let's Encrypt

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Get certificate
sudo certbot certonly --standalone -d yourdomain.com

# Update nginx.conf with SSL configuration
```

### Local Server Deployment

```bash
# On your local server
chmod +x deploy/deploy-local.sh
./deploy/deploy-local.sh
```

## 🔄 CI/CD Pipeline

### Jenkins Setup

#### 1. Install Jenkins

```bash
# On your Jenkins server
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

#### 2. Configure Jenkins

1. Install required plugins:
   - Docker Pipeline
   - Git
   - Pipeline
   - Credentials Binding

2. Create credentials:
   - Docker Registry (Docker Hub)
   - Deploy SSH Key
   - Deploy Server IP
   - Deploy User

3. Create Pipeline Job:
   - Point to your repository
   - Select `Pipeline script from SCM`
   - Set script path to `Jenkinsfile`

#### 3. Jenkinsfile Triggers

```groovy
// Automatic deployment on push to main branch
// Manual approval for other branches
```

### Pipeline Stages

1. **Checkout** - Clone repository
2. **Validate** - Check configuration files
3. **Build Backend** - Build Docker image
4. **Build Frontend** - Build Docker image
5. **Push Images** - Push to Docker Registry (main branch only)
6. **Deploy** - Deploy to server (main branch only)
7. **Health Check** - Verify services are healthy

## 📝 Git Workflow

### Setting Up Git

```bash
# Clone the repository
git clone https://github.com/your-username/fullstack-app.git
cd fullstack-app

# Configure Git
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Create a new branch for your feature
git checkout -b feature/your-feature-name
```

### Commit Workflow

```bash
# Make changes
echo "improvements" >> file.txt

# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add user authentication"

# Push to remote
git push origin feature/your-feature-name
```

### Pull Request / Merge to Main

```bash
# Push your branch
git push origin feature/your-feature-name

# Create Pull Request on GitHub
# After approval, merge to main

# Jenkins will automatically:
# 1. Run tests
# 2. Build Docker images
# 3. Push images to registry
# 4. Deploy to production
```

### Branching Strategy

```
main (production)
 ├── feature/user-auth
 ├── feature/payment-integration
 ├── bugfix/login-issue
 └── develop (staging)
```

## 📚 API Documentation

### Product Schema

```javascript
{
  "_id": "ObjectId",
  "name": "Product Name",
  "description": "Product Description",
  "price": 99.99,
  "category": "Electronics|Clothing|Books|Food|Other",
  "stock": 10,
  "image": "https://...",
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### Response Format

**Success Response:**
```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message"
}
```

**Paginated Response:**
```json
{
  "success": true,
  "count": 10,
  "total": 50,
  "pages": 5,
  "currentPage": 1,
  "data": [ ... ]
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error description"
}
```

## 🐛 Troubleshooting

### Common Issues

**MongoDB Connection Error**
```bash
# Check if MongoDB is running
docker-compose logs mongodb

# Restart MongoDB
docker-compose restart mongodb
```

**Backend not responding**
```bash
# Check backend health
curl http://localhost:3000/api/health

# View backend logs
docker-compose logs -f backend
```

**Frontend not loading**
```bash
# Check if frontend container is running
docker ps

# Rebuild frontend
docker-compose up --build frontend
```

**Port already in use**
```bash
# Find process using port
lsof -i :3000
lsof -i :4200

# Kill process
kill -9 <PID>
```

### Docker Commands

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs -f [service-name]

# Execute command in container
docker-compose exec backend npm test

# Rebuild images
docker-compose build --no-cache

# Remove containers and volumes
docker-compose down -v
```

## 📊 Monitoring

### Health Check Endpoints

```bash
# Backend health
curl http://localhost:3000/api/health

# Frontend health
curl http://localhost:4200
```

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb

# Last 100 lines
docker-compose logs --tail=100 backend
```

## 🔐 Security Best Practices

1. **Environment Variables**: Never commit `.env` files
2. **Secrets Management**: Use Jenkins credentials for sensitive data
3. **Database**: Always use strong passwords
4. **CORS**: Configure properly for your domain
5. **SSL/TLS**: Use HTTPS in production
6. **Input Validation**: Validate all user inputs
7. **Rate Limiting**: Implement rate limiting in production

## 📄 License

MIT License - see LICENSE file for details

## 👤 Author

Your Name - [@yourusername](https://github.com/yourusername)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For issues and questions, please open an issue on GitHub or contact the team.

**Last Updated:** January 2024
