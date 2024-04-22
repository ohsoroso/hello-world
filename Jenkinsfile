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
                // Using Maven on Windows
                bat 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Building Docker image on Windows
                    bat "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Logging into Docker Hub and pushing an image on Windows
                        bat "echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin registry.hub.docker.com"
                        bat "docker push ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Setting Docker environment for Minikube and deploying using kubectl on Windows
                    bat 'minikube -p minikube docker-env > minikube_docker_env.bat'
                    bat 'call minikube_docker_env.bat'
                    bat 'kubectl apply -f deployment.yaml'
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
