pipeline {
    agent any

    options {
        disableConcurrentBuilds()
    }

    environment {
        IMAGE = "payment-api"
        TAG = "${BUILD_NUMBER}"
        BRANCH = "main"
    }

    stages {
        stage('Build') {
            steps {
                bat '''
                    docker build ^
                      --build-arg BUILD_NUMBER=%BUILD_NUMBER% ^
                      --build-arg GIT_COMMIT=%GIT_COMMIT% ^
                      --build-arg BRANCH_NAME=%BRANCH% ^
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
                    docker stop payment >nul 2>&1 || echo No existing payment container
                    docker rm payment >nul 2>&1 || echo No existing payment container

                    docker run -d ^
                      --name payment ^
                      -p 8080:8080 ^
                      %IMAGE%:%TAG%

                    echo.
                    echo ===== DEPLOYMENT INFORMATION =====
                    echo Jenkins Build: %BUILD_NUMBER%
                    echo Git Commit: %GIT_COMMIT%
                    echo Branch: %BRANCH%
                    echo Docker Image: %IMAGE%:%TAG%
                    echo ====================================

                    docker inspect payment --format="{{index .Config.Labels \"org.opencontainers.image.build\"}}"
                    docker inspect payment --format="{{index .Config.Labels \"org.opencontainers.image.revision\"}}"
                    docker inspect payment --format="{{index .Config.Labels \"org.opencontainers.image.branch\"}}"
                '''
            }
        }
    }
}