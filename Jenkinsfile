pipeline {
    agent any

    stages {
        stage('Set Docker Env') {
            steps {
                script {
                    bat "minikube -p minikube docker-env --shell cmd > minikube_docker_env.bat"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Apply the Docker environment settings
                    bat "call minikube_docker_env.bat"
                    // Build the Docker image using the Docker daemon in Minikube
                    bat "docker build -t ${env.DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Apply the Docker environment settings again
                    bat "call minikube_docker_env.bat"
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
                    // Apply the Docker environment settings once more
                    bat "call minikube_docker_env.bat"
                    // Use kubectl to apply your deployment
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
