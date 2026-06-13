pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        // Docker Registry Configuration
        REGISTRY = 'docker.io'
        REGISTRY_CREDENTIALS = credentials('docker-credentials')
        IMAGE_NAME = "${REGISTRY}/your-username/fullstack-app"
        
        // Backend Configuration
        BACKEND_IMAGE = "${IMAGE_NAME}:backend-${BUILD_NUMBER}"
        BACKEND_LATEST = "${IMAGE_NAME}:backend-latest"
        
        // Frontend Configuration
        FRONTEND_IMAGE = "${IMAGE_NAME}:frontend-${BUILD_NUMBER}"
        FRONTEND_LATEST = "${IMAGE_NAME}:frontend-latest"
        
        // Deployment Configuration
        DEPLOY_SERVER = credentials('deploy-server-ip')
        DEPLOY_USER = credentials('deploy-user')
        DEPLOY_KEY = credentials('deploy-ssh-key')
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Checking out code from Git ==='
                checkout scm
                sh 'git log -1 --oneline'
            }
        }

        stage('Validate') {
            parallel {
                stage('Backend Validation') {
                    steps {
                        echo '=== Validating Backend ==='
                        dir('backend') {
                            sh '''
                                echo "Checking package.json..."
                                test -f package.json
                                test -f Dockerfile
                                echo "Backend validation passed!"
                            '''
                        }
                    }
                }

                stage('Frontend Validation') {
                    steps {
                        echo '=== Validating Frontend ==='
                        dir('frontend') {
                            sh '''
                                echo "Checking package.json..."
                                test -f package.json
                                test -f Dockerfile
                                echo "Frontend validation passed!"
                            '''
                        }
                    }
                }
            }
        }

        stage('Build Backend') {
            steps {
                echo '=== Building Backend Docker Image ==='
                dir('backend') {
                    sh '''
                        docker build -t ${BACKEND_IMAGE} .
                        docker tag ${BACKEND_IMAGE} ${BACKEND_LATEST}
                        echo "Backend image built: ${BACKEND_IMAGE}"
                    '''
                }
            }
        }

        stage('Build Frontend') {
            steps {
                echo '=== Building Frontend Docker Image ==='
                dir('frontend') {
                    sh '''
                        docker build -t ${FRONTEND_IMAGE} .
                        docker tag ${FRONTEND_IMAGE} ${FRONTEND_LATEST}
                        echo "Frontend image built: ${FRONTEND_IMAGE}"
                    '''
                }
            }
        }

        stage('Push Images') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Pushing Docker Images to Registry ==='
                sh '''
                    echo "${REGISTRY_CREDENTIALS_PSW}" | docker login -u "${REGISTRY_CREDENTIALS_USR}" --password-stdin
                    
                    docker push ${BACKEND_IMAGE}
                    docker push ${BACKEND_LATEST}
                    
                    docker push ${FRONTEND_IMAGE}
                    docker push ${FRONTEND_LATEST}
                    
                    docker logout
                    echo "Images pushed successfully!"
                '''
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Deploying to Production ==='
                sh '''
                    echo "${DEPLOY_KEY}" > deploy-key.pem
                    chmod 600 deploy-key.pem
                    
                    # Copy deployment script
                    scp -i deploy-key.pem -o StrictHostKeyChecking=no \
                        deploy/deploy-aws.sh ${DEPLOY_USER}@${DEPLOY_SERVER}:/tmp/
                    
                    # Execute deployment
                    ssh -i deploy-key.pem -o StrictHostKeyChecking=no \
                        ${DEPLOY_USER}@${DEPLOY_SERVER} \
                        "bash /tmp/deploy-aws.sh ${BACKEND_IMAGE} ${FRONTEND_IMAGE}"
                    
                    rm deploy-key.pem
                    echo "Deployment completed!"
                '''
            }
        }

        stage('Health Check') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Performing Health Checks ==='
                sh '''
                    sleep 10
                    
                    # Check backend health
                    curl -f http://localhost:3000/api/health || exit 1
                    
                    # Check frontend health
                    curl -f http://localhost:4200 || exit 1
                    
                    echo "Health checks passed!"
                '''
            }
        }
    }

    post {
        always {
            echo '=== Cleaning up workspace ==='
            cleanWs()
        }

        success {
            echo '=== Pipeline executed successfully ==='
            // Send success notification
        }

        failure {
            echo '=== Pipeline failed! ==='
            // Send failure notification
        }
    }
}
