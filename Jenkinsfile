pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1c'
        ACCOUNT_ID = '795708474003'
        REPO_NAME = 'my-app-repo'
        ECR_URL = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        AWS_CREDENTIALS = 'aws-credentials' // Jenkins credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-username>/my-ecr-project.git'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withAWS(credentials: "${AWS_CREDENTIALS}", region: "${AWS_REGION}") {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${REPO_NAME}:${IMAGE_TAG} .
                    docker tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Clean Up') {
            steps {
                sh '''
                    docker rmi ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG} || true
                    docker rmi ${REPO_NAME}:${IMAGE_TAG} || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Successfully pushed image to ECR: ${ECR_URL}/${REPO_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}

