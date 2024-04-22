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
                bat "wsl mvn clean package"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "wsl docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat "wsl bash -c 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin registry.hub.docker.com && docker push ${env.DOCKER_IMAGE}'"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    bat "wsl kubectl apply -f C:\Users\notfu\IdeaProjects\helloWorld\deployment.yaml"
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
