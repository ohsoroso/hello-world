pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ohsoroso/hello-world:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ohsoroso/hello-world.git'
            }
        }

        stage('Build') {
            steps {
                bat "mvn clean package"
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${env.DOCKER_IMAGE} ."
            }
        }

        // New stage for building Docker image using Minikube's Docker daemon
        stage('Build Docker Image with Minikube') {
            steps {
                script {
                    // Execute minikube command and directly use its Docker daemon to build image
                    bat "minikube docker-env && docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat "echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin"
                        bat "docker push ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    bat "minikube docker-env"
                    bat "kubectl apply -f deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline successfully executed!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
