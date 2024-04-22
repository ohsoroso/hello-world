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
                    powershell '''
                    $Env:DOCKER_TLS_VERIFY = "1"
                    $Env:DOCKER_HOST = "tcp://127.0.0.1:58634"
                    $Env:DOCKER_CERT_PATH = "C:\\Users\\notfu\\.minikube\\certs"
                    $Env:MINIKUBE_ACTIVE_DOCKERD = "minikube"
                    & minikube -p minikube docker-env --shell powershell | Invoke-Expression
                    docker build -t ${env.DOCKER_IMAGE} .
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        powershell "echo $env:DOCKER_PASSWORD | docker login -u $env:DOCKER_USERNAME --password-stdin"
                        powershell "docker push ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    powershell '''
                    & minikube -p minikube docker-env --shell powershell | Invoke-Expression
                    kubectl apply -f deployment.yaml
                    '''
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
