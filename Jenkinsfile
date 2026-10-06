pipeline {
    agent any

    environment {
        IMAGE = "payment-api"
        TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                bat 'docker build -t %IMAGE%:%TAG% .'
            }
        }

        stage('Test') {
            steps {
                bat 'docker run --rm %IMAGE%:%TAG% python -m pytest'
            }
        }

        stage('Tag') {
            steps {
                bat 'docker tag %IMAGE%:%TAG% %IMAGE%:latest'
            }
        }

        stage('Deploy') {
            steps {
                bat '''
                    docker stop payment || exit /b 0
                    docker rm payment || exit /b 0
                    docker run -d --name payment -p 8080:8080 %IMAGE%:%TAG%
                '''
            }
        }
    }
}
