pipeline {
    agent { label 'agent' }

    stages {
        stage("Build") {
            steps {
                sh "docker build -t gitxjenkins:${BUILD_NUMBER} ."
            }
        }

        stage("Login") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "docker_cred",
                    passwordVariable: "DOCKER_PASS",
                    usernameVariable: "DOCKER_USER"
                )]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage("Push") {
            steps {
                sh "docker tag gitxjenkins:${BUILD_NUMBER} pareekaditya/gitxjenkins:${BUILD_NUMBER}"
                sh "docker push pareekaditya/gitxjenkins:${BUILD_NUMBER}"
            }
        }
    }
}
