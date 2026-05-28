pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "fiazsh/flask-nginx-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Code Checkout') {
            steps {
                echo "Pulling code from GitHub"
                git branch: 'main',
                    changelog: false,
                    credentialsId: 'git-cred',
                    poll: false,
                    url: 'https://github.com/Fiazshafqat/dockerized-flask-app-nginx-reverse-proxy.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo "Building Docker image"
                sh 'docker compose build'
            }
        }

        stage('Image Tag, Login & Push to Docker Hub') {
            steps {
                script {
                    echo "Tagging Docker image"

                    sh """
                    docker tag flask_app:latest $DOCKERHUB_REPO:$IMAGE_TAG
                    docker tag flask_app:latest $DOCKERHUB_REPO:latest
                    """

                    withCredentials([usernamePassword(
                        credentialsId: "docker-cred",
                        usernameVariable: "DOCKER_USER",
                        passwordVariable: "DOCKER_PASS"
                    )]) {

                        echo "Logging into Docker Hub"

                        sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        """

                        echo "Pushing image to Docker Hub"

                        sh """
                        docker push $DOCKERHUB_REPO:$IMAGE_TAG
                        docker push $DOCKERHUB_REPO:latest
                        """
                    }
                }
            }
        }

        stage('Deploy Containers') {
            steps {
                echo "Deploying containers using docker compose"
                sh 'docker compose down || true'
                sh 'docker compose up -d'
            }
        }
    }

    post {

        success {
            echo "✅ Pipeline SUCCESS: Build, Push & Deployment completed successfully"
        }

        failure {
            echo "❌ Pipeline FAILED: Check logs for errors"
        }

        always {
            echo "📌 Cleaning workspace (optional step)"
            cleanWs()
        }
    }
}
