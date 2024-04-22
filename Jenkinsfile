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
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
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
                    sh '''
                    eval $(minikube -p minikube docker-env)
                    kubectl apply -f deployment.yaml
                    '''
                }
            }
        }
    } // This closing brace was missing, causing the issue

    post {
        success {
            echo 'Pipeline successfully executed!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}