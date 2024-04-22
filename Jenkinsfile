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

        stage('Configure Minikube Docker Environment') {
            steps {
                script {
                    // Retrieve environment commands from minikube docker-env and set them manually
                    def dockerEnv = bat(script: "minikube docker-env --shell cmd", returnStdout: true).trim()
                    dockerEnv.tokenize('\n').each {
                        line ->
                        if (line.startsWith("SET")) {
                            def (key, value) = line.drop(4).split('=', 2)
                            env."$key" = "$value".trim()
                        }
                    }
                }
            }
        }

        stage('Build Docker Image with Minikube') {
            steps {
                // Now the Docker commands should use Minikube's Docker daemon
                bat "docker build -t ${env.DOCKER_IMAGE} ."
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
                    bat "kubectl config use-context minikube"
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
