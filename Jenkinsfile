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
                script {
                    // Ensure Docker is accessible via Windows command line
                    bat "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat "echo %DOCKER_PASSWORD%| docker login -u %DOCKER_USERNAME% --password-stdin registry.hub.docker.com"
                        bat "docker push ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Adjust this if Minikube is being run directly on Windows
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
