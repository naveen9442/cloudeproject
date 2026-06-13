# Jenkins CI/CD Setup Guide

## 🔧 Installing Jenkins

### On Ubuntu 20.04/22.04

```bash
# Update system
sudo apt-get update

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Java and Jenkins
sudo apt-get install openjdk-11-jdk
sudo apt-get update
sudo apt-get install jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### With Docker

```bash
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -e JAVA_OPTS="-Xmx512m" \
  jenkins/jenkins:latest
```

## 🔑 Initial Configuration

### 1. Access Jenkins

Open your browser and go to: `http://localhost:8080` or `http://your-server:8080`

### 2. Unlock Jenkins

1. Copy the initial admin password from above
2. Paste it into the unlock field
3. Click "Continue"

### 3. Install Suggested Plugins

1. Click "Install suggested plugins"
2. Wait for installation to complete

### 4. Create First Admin User

1. Enter your credentials:
   - Username: `admin` (or your preference)
   - Password: (create a strong password)
   - Full name: Your Name
   - Email: your.email@example.com
2. Click "Save and Continue"

### 5. Configure Jenkins URL

1. Set Jenkins URL to: `http://your-jenkins-server:8080/`
2. Click "Save and Finish"

## 📦 Install Required Plugins

### Method 1: Via GUI

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Go to **Available** tab
3. Search and install:
   - Docker Pipeline
   - Docker
   - Git
   - GitHub
   - Pipeline
   - Credentials Binding
   - SSH Credentials
   - Blue Ocean (optional, for better UI)

4. Restart Jenkins after installation

### Method 2: Via Script

```bash
# Create plugins.txt
cat > plugins.txt << 'EOF'
docker-plugin:latest
docker-workflow:latest
git:latest
github:latest
workflow-aggregator:latest
credentials:latest
ssh-slaves:latest
EOF

# Install plugins
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin $(cat plugins.txt)
```

## 🔐 Configure Credentials

### 1. Docker Hub Credentials

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click **Global credentials (unrestricted)**
3. Click **Add Credentials**

**Type:** Username with password
- Username: your-docker-hub-username
- Password: your-docker-hub-password
- ID: `docker-credentials`
- Description: Docker Hub Credentials

4. Click **Create**

### 2. SSH Key for Deployment

1. Go to **Manage Credentials** → **Global**
2. Click **Add Credentials**

**Type:** SSH Username with private key
- Username: `ubuntu` (or your deployment user)
- Private Key: Paste your EC2 .pem file content
- ID: `deploy-ssh-key`
- Passphrase: (if your key has one)

3. Click **Create**

### 3. Server Deployment Details

1. Click **Add Credentials**

**Type:** Username with password
- Username: your-server-ip
- Password: (or use the SSH key method above)
- ID: `deploy-server-ip`

2. Click **Create**

### 4. GitHub Token (Optional)

For GitHub webhooks:

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token with `repo` and `admin:repo_hook` scopes
3. Copy the token
4. In Jenkins → Add Credentials:

**Type:** Secret text
- Secret: Paste your GitHub token
- ID: `github-token`

5. Click **Create**

## 🏗️ Create Jenkins Pipeline Job

### Step 1: Create New Job

1. Click **New Item**
2. Enter name: `fullstack-app-pipeline`
3. Select **Pipeline**
4. Click **OK**

### Step 2: Configure Pipeline

1. **Build Triggers**
   - Check: "GitHub hook trigger for GITScm polling"
   - Or: "Poll SCM" with `H/5 * * * *` (every 5 minutes)

2. **Pipeline**
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/your-username/fullstack-app.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

3. Click **Save**

### Step 3: Configure GitHub Webhook (Optional)

1. Go to GitHub repository
2. Settings → Webhooks → Add webhook
3. Payload URL: `http://your-jenkins-server:8080/github-webhook/`
4. Content type: `application/json`
5. Events: Push events
6. Click **Add webhook**

## 🔄 Jenkinsfile Customization

Update these values in your Jenkinsfile:

```groovy
environment {
    REGISTRY = 'docker.io'
    IMAGE_NAME = 'your-username/fullstack-app'  // Change this
    DEPLOY_SERVER = '1.2.3.4'                   // Change this
    DEPLOY_USER = 'ubuntu'
}
```

## 📋 Test the Pipeline

### Method 1: Trigger Manually

1. Click on your job
2. Click **Build Now**
3. Monitor in **Console Output**

### Method 2: Trigger via Git Push

```bash
# Make a small change
echo "# Updated" >> README.md

# Commit and push
git add README.md
git commit -m "test: trigger Jenkins pipeline"
git push origin main
```

Check Jenkins - it should automatically trigger!

## 🔍 Monitor Pipeline Execution

### View Console Output

1. Click on the build number
2. Click **Console Output**
3. View real-time logs

### View Stage View

If Blue Ocean is installed:
1. Click **Open Blue Ocean**
2. See visual pipeline representation

### View Build History

1. Click on job name
2. See all past builds with status

## 🐛 Troubleshooting Jenkins

### Common Issues

**Pipeline fails at Docker build:**
```bash
# Ensure Jenkins user has Docker permission
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Credentials not found:**
```bash
# Verify credential ID in Jenkinsfile matches
# Go to Credentials → view ID
# Use exact ID in environment block
```

**Permission denied on deploy key:**
```bash
# Check SSH key permissions
chmod 600 ~/.ssh/id_rsa
# Add Jenkins user to authorized_keys on deploy server
```

**Git authentication fails:**
```bash
# Add GitHub deploy key
# Go to GitHub → Settings → Deploy keys → Add key
# Use Jenkins SSH key public part
```

## 🚀 Deployment Workflow

### Step 1: Developer Creates Feature

```bash
git checkout -b feature/new-feature
# ... make changes ...
git commit -m "feat: add new feature"
git push origin feature/new-feature
```

### Step 2: Pull Request Created

On GitHub:
1. Create Pull Request to `main`
2. Add description of changes
3. Request review

### Step 3: Jenkins Validates PR

Jenkins can run validation:
- Code quality checks
- Tests
- Build verification

### Step 4: PR Approved & Merged

1. PR reviewed and approved
2. PR merged to `main`

### Step 5: Jenkins Deploys

1. Git webhook triggers Jenkins
2. Pipeline runs:
   - Checkout code
   - Validate
   - Build backend
   - Build frontend
   - Push to Docker Hub
   - Deploy to server
   - Health check

## 📊 Pipeline Stages Explained

1. **Checkout**: Clone repository from Git
2. **Validate**: Check configuration files
3. **Build Backend**: Build Node.js Docker image
4. **Build Frontend**: Build Angular Docker image
5. **Push Images**: Push to Docker registry
6. **Deploy**: SSH to server and deploy
7. **Health Check**: Verify services are running

## 🔐 Security Best Practices

1. **Use Credentials Plugin**: Never hardcode secrets
2. **Restrict Job Permissions**: Set who can build/deploy
3. **Use SSH Keys**: Better than passwords
4. **Rotate Secrets**: Update regularly
5. **Audit Logs**: Monitor Jenkins activity
6. **Scan Images**: Use container scanning tools

## 📈 Advanced Features

### Email Notifications

```groovy
post {
    failure {
        emailext (
            to: 'your.email@example.com',
            subject: "Job '${env.JOB_NAME}' failed",
            body: "Build failed: ${env.BUILD_URL}"
        )
    }
}
```

### Slack Notifications

```groovy
post {
    always {
        slackSend(
            color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
            message: "Build ${env.BUILD_NUMBER} - ${currentBuild.result}"
        )
    }
}
```

### Parallel Builds

```groovy
parallel {
    stage('Build Backend') {
        steps { ... }
    }
    stage('Build Frontend') {
        steps { ... }
    }
}
```

## 🔄 Maintenance

### Backup Jenkins

```bash
# Backup Jenkins data
tar -czf jenkins-backup.tar.gz /var/lib/jenkins/

# Upload to S3
aws s3 cp jenkins-backup.tar.gz s3://your-bucket/
```

### Cleanup Old Builds

1. Go to **Manage Jenkins** → **Configure System**
2. Set **Build Discarder** per job
3. Example: Keep last 30 builds, max 90 days

### Monitor Jenkins Health

```bash
# Check Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Check disk space
df -h /var/lib/jenkins

# Monitor Java process
ps aux | grep jenkins
```

## 📞 Support & Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- Pipeline Syntax: https://www.jenkins.io/doc/book/pipeline/syntax/
- Docker Plugin: https://plugins.jenkins.io/docker-plugin/
- GitHub Integration: https://plugins.jenkins.io/github/

---

## ✅ Jenkins Checklist

- [ ] Jenkins installed and running
- [ ] Initial admin user created
- [ ] Required plugins installed
- [ ] Docker Hub credentials configured
- [ ] SSH deployment key added
- [ ] GitHub credentials configured (if needed)
- [ ] Pipeline job created
- [ ] Jenkinsfile in repository
- [ ] GitHub webhook configured
- [ ] Test pipeline execution successful
- [ ] Email/Slack notifications configured
- [ ] Backups scheduled
- [ ] Monitoring in place

Your Jenkins CI/CD pipeline is now ready! 🎉
