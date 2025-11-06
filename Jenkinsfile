pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ACCOUNT_ID = '795708474003'
        REPO_NAME = 'my-app-repo'
        ECR_URL = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG = "${env.BUILD_NUMBER}"    // numeric tag like 1, 2, 3...
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Anvesh-ansh259/my-ecr-project.git'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${REPO_NAME}:${IMAGE_TAG} .
                    docker tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                    docker tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}/${REPO_NAME}:latest
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                    docker push ${ECR_URL}/${REPO_NAME}:latest
                '''
            }
        }

        stage('Clean Up') {
            steps {
                sh '''
                    docker rmi ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG} || true
                    docker rmi ${ECR_URL}/${REPO_NAME}:latest || true
                    docker rmi ${REPO_NAME}:${IMAGE_TAG} || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Image pushed successfully:"
            echo "   ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}"
            echo "   ${ECR_URL}/${REPO_NAME}:latest"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
