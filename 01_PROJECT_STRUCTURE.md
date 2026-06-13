# Full Stack Application - Node.js + Angular + MongoDB + Jenkins + Docker

## Project Structure

```
my-fullstack-app/
├── backend/                      # Node.js Express Server
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
│   ├── .gitignore
│   ├── Dockerfile
│   ├── package.json
│   └── README.md
│
├── frontend/                     # Angular Application
│   ├── src/
│   │   ├── app/
│   │   │   ├── components/
│   │   │   │   ├── product-list/
│   │   │   │   ├── product-create/
│   │   │   │   └── product-update/
│   │   │   ├── services/
│   │   │   │   └── product.service.ts
│   │   │   ├── app.module.ts
│   │   │   ├── app-routing.module.ts
│   │   │   └── app.component.ts
│   │   ├── index.html
│   │   ├── main.ts
│   │   └── styles.css
│   ├── angular.json
│   ├── package.json
│   ├── tsconfig.json
│   ├── .gitignore
│   ├── Dockerfile
│   └── README.md
│
├── docker-compose.yml            # Local Development
├── Jenkinsfile                   # CI/CD Pipeline
├── deploy/                       # Deployment Scripts
│   ├── deploy-aws.sh
│   ├── deploy-local.sh
│   ├── setup-server.sh
│   └── env-template.sh
├── .gitignore
├── README.md
└── DEPLOYMENT_GUIDE.md
```

## Quick Start Commands

```bash
# Clone and setup
git clone <your-repo>
cd my-fullstack-app

# Local development with Docker Compose
docker-compose up -d

# Access applications
# Frontend: http://localhost:4200
# Backend API: http://localhost:3000
# MongoDB: localhost:27017
```

## Files Included in This Package
- ✅ Complete Backend Code (Node.js + Express)
- ✅ Complete Frontend Code (Angular)
- ✅ Docker Files (Docker Compose)
- ✅ Jenkins Pipeline (Jenkinsfile)
- ✅ Deployment Scripts (AWS + Local)
- ✅ Environment Configuration
- ✅ Git Setup Guide
- ✅ Complete Documentation

