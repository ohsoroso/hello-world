pipeline {
    agent any // Run on any available agent

    environment {
        DOCKER_IMAGE = 'ohsoroso/hello-world:latest'
        // Ensure you replace 'yourdockerhubusername' with your actual Docker Hub username or your private registry URL
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ohsoroso/hello-world.git' // Replace with your repository URL
            }
        }

        stage('Build') {
            steps {
                // Using Maven to build the Java project
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Building Docker image
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Commands to set up environment to use Minikube’s Docker daemon
                    sh 'eval $(minikube -p minikube docker-env)'
                    // Commands to deploy to Kubernetes
                    sh 'kubectl apply -f deployment.yaml'
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
