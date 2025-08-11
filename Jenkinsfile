pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds') 
        IMAGE_NAME = 'maleknassar/vprofile'           
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build WAR') {
            steps {
                // Run Maven inside Docker to build WAR (avoids needing Maven on Jenkins itself)
                sh '''
                docker run --rm -v $PWD:/app -w /app maven:3.9.6-eclipse-temurin-17 mvn clean package
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
                    dockerImage = docker.build("${IMAGE_NAME}:${tag}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push()
                    // Optionally push 'latest' tag too
                    dockerImage.push('latest')
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
