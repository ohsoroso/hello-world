pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ohsoroso/hello-world:latest'
    }

    stages {

    stage('Some PowerShell Stage') {
        steps {
            script {
                // Setting the execution policy for this process only
                powershell script: """
                    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force
                    # Your PowerShell commands here
                    \$minikubeDockerEnv = minikube -p minikube docker-env --shell powershell
                    if (\$minikubeDockerEnv -match 'false') {
                        Write-Error 'Failed to get Docker environment settings'
                        exit 1
                    }
                    Invoke-Expression \$minikubeDockerEnv
                    kubectl apply -f deployment.yaml
                """
            }
        }
    }


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
                        bat "docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%"
                        bat "docker push ${env.DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Using PowerShell to execute the Docker environment command for Minikube
                    powershell """
                        \$minikubeDockerEnv = minikube -p minikube docker-env --shell powershell
                        Invoke-Expression \$minikubeDockerEnv
                        kubectl apply -f deployment.yaml
                    """
                }
            }
        }
    }
}
