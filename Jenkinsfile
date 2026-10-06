pipeline {
    agent any

    options {
        disableConcurrentBuilds()
    }

    environment {
        IMAGE = "payment-api"
        TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                bat '''
                    docker build ^
                      --build-arg BUILD_NUMBER=%BUILD_NUMBER% ^
                      --build-arg GIT_COMMIT=%GIT_COMMIT% ^
                      --build-arg BRANCH_NAME=%BRANCH_NAME% ^
                      -t %IMAGE%:%TAG% .
                '''
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

        stage('Push') {
            steps {
                bat '''
                    docker tag %IMAGE%:%TAG% localhost:5000/%IMAGE%:%TAG%
                    docker push localhost:5000/%IMAGE%:%TAG%
                '''
            }
        }

        stage('Deploy') {
            steps {
                bat '''
                    docker stop payment || exit /b 0
                    docker rm payment || exit /b 0

                    docker run -d ^
                      --name payment ^
                      -p 8080:8080 ^
                      %IMAGE%:%TAG%

                    echo.
                    echo ===== DEPLOYMENT INFORMATION =====
                    echo Jenkins Build: %BUILD_NUMBER%
                    echo Git Commit: %GIT_COMMIT%
                    echo Branch: %BRANCH_NAME%
                    echo Docker Image: %IMAGE%:%TAG%
                    echo ====================================
                '''
            }
        }
    }
}