pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'maleknassar/vprofile-app'
        DOCKER_IMAGE_TAG  = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'local', url: 'https://github.com/malek7x/vprofile-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
