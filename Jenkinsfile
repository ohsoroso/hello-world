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
                bat 'mvn clean package'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Setting up Docker to use Minikube’s Docker daemon
                    bat "minikube -p minikube docker-env --shell cmd | Invoke-Expression"
                    bat "docker build -t hello-world:latest ."
                    bat "docker push hello-world:latest"
                }
            }
        }


        stage('Deploy to Minikube') {
            steps {
                script {
                    // Using Minikube’s kubectl to apply the Kubernetes manifests
                    bat "minikube -p minikube kubectl -- apply -f deployment.yaml"
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
