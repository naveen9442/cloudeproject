# Quick Reference Guide

## 🚀 Quick Commands

### Start Application
```bash
# Local development
./deploy-local.sh

# Or manually
docker-compose up -d
docker-compose logs -f
```

### Stop Application
```bash
docker-compose down

# Remove all data
docker-compose down -v
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb

# Last 50 lines
docker-compose logs --tail=50
```

### Rebuild Images
```bash
docker-compose build --no-cache
docker-compose up -d --build
```

## 📝 Git Commands

### Initial Setup
```bash
git clone <your-repo-url>
cd fullstack-app
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Create and Push Feature
```bash
git checkout -b feature/my-feature
# ... make changes ...
git add .
git commit -m "feat: add my feature"
git push origin feature/my-feature
```

### Update from Main
```bash
git pull origin main
git rebase origin/main
```

### View Changes
```bash
git status
git diff
git log --oneline -10
```

## 🔌 API Testing

### Health Check
```bash
curl http://localhost:3000/api/health
```

### Get All Products
```bash
curl http://localhost:3000/api/products
```

### Create Product
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Product Name",
    "description": "Description",
    "price": 99.99,
    "category": "Electronics",
    "stock": 10
  }'
```

### Get Product by ID
```bash
curl http://localhost:3000/api/products/PRODUCT_ID
```

### Update Product
```bash
curl -X PUT http://localhost:3000/api/products/PRODUCT_ID \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Name",
    "price": 199.99
  }'
```

### Delete Product
```bash
curl -X DELETE http://localhost:3000/api/products/PRODUCT_ID
```

### Search Products
```bash
curl "http://localhost:3000/api/products?search=laptop"
```

### Filter by Category
```bash
curl "http://localhost:3000/api/products?category=Electronics"
```

### Pagination
```bash
curl "http://localhost:3000/api/products?page=1&limit=10"
```

## 🐳 Docker Commands

### List Containers
```bash
docker ps          # Running
docker ps -a       # All
```

### Execute Commands
```bash
docker-compose exec backend npm test
docker-compose exec frontend npm test
docker exec fullstack-mongodb mongosh
```

### View Logs
```bash
docker logs -f fullstack-backend
docker logs -f fullstack-frontend
docker logs -f fullstack-mongodb
```

### Clean Up
```bash
docker system prune              # Remove unused
docker volume prune              # Remove unused volumes
docker network prune             # Remove unused networks
```

## 📊 MongoDB Commands

### Connect to MongoDB
```bash
# Using docker-compose
docker-compose exec mongodb mongosh

# Inside mongosh
use fullstack_app
show collections
db.products.find()
db.products.count()
```

### Backup Database
```bash
docker-compose exec mongodb mongodump --out /backup
docker cp fullstack-mongodb:/backup ./backup
```

### Restore Database
```bash
docker cp ./backup fullstack-mongodb:/backup
docker-compose exec mongodb mongorestore /backup
```

## 🔄 Deployment Commands

### Local Server
```bash
chmod +x deploy-local.sh
./deploy-local.sh
```

### AWS Server
```bash
# Initial setup
ssh -i key.pem ubuntu@server-ip
curl -sSL https://url/setup-server.sh | bash

# Deployment
cd /opt/fullstack-app
./deploy/deploy-aws.sh backend-image frontend-image
```

## ⚙️ Environment Setup

### Backend (.env)
```
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://mongodb:27017/fullstack_app
CORS_ORIGIN=http://localhost:4200
JWT_SECRET=secret_key_here
```

### Production (.env)
```
NODE_ENV=production
MONGODB_URI=mongodb://admin:password@mongodb:27017/fullstack_app?authSource=admin
CORS_ORIGIN=https://yourdomain.com
JWT_SECRET=secure_random_key
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Frontend Tests
```bash
cd frontend
npm test
```

### Integration Tests
```bash
# Run all tests
npm test --all
```

## 🔐 Security Commands

### Generate JWT Secret
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### MongoDB Password Hash
```bash
# Use bcrypt to hash passwords
npm install bcrypt
```

## 📱 Access Points

### Local Development
- Frontend: http://localhost:4200
- Backend API: http://localhost:3000
- MongoDB: localhost:27017
- Health Check: http://localhost:3000/api/health

### Production (Example)
- Frontend: https://yourdomain.com
- Backend API: https://yourdomain.com/api
- MongoDB: (internal only)

## 🚨 Emergency Commands

### Reset Everything
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d --build
```

### View Real-time Stats
```bash
docker stats
```

### Kill Container
```bash
docker kill fullstack-backend
docker-compose restart backend
```

### Check Disk Space
```bash
docker system df
```

## 📝 Useful Aliases

Add to your ~/.bashrc or ~/.zshrc:

```bash
alias dk='docker'
alias dkc='docker-compose'
alias dkl='docker logs -f'
alias dkps='docker ps'
alias dkdown='docker-compose down'
alias dkup='docker-compose up -d'

# Git aliases
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gs='git status'
```

## 📚 Documentation Links

- Docker: https://docs.docker.com
- Docker Compose: https://docs.docker.com/compose
- Node.js: https://nodejs.org/docs
- Express: https://expressjs.com
- Angular: https://angular.io/docs
- MongoDB: https://docs.mongodb.com
- Jenkins: https://www.jenkins.io/doc
- Git: https://git-scm.com/doc

## 🔗 Resource Limits

### Docker Container Limits
```yaml
# In docker-compose.yml
deploy:
  resources:
    limits:
      cpus: '1'
      memory: 512M
    reservations:
      cpus: '0.5'
      memory: 256M
```

### Database Optimization
```javascript
// Add indexes in MongoDB
db.products.createIndex({ name: "text", description: "text" })
db.products.createIndex({ category: 1 })
db.products.createIndex({ createdAt: -1 })
```

## 💡 Pro Tips

1. **Use .env files** for all configuration
2. **Never commit secrets** to Git
3. **Regular backups** of MongoDB
4. **Monitor logs** for errors
5. **Use health checks** for reliability
6. **Version your images** with Git tags
7. **Test locally** before deploying
8. **Document changes** in commit messages

---

For more help, refer to the main README.md
