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

        stage("Kubernetes Test") {
            steps {
                sh "whoami"
                sh "which kubectl"
                sh "kubectl version --client"
                sh "kubectl get nodes"
            }
        }

        stage("Deploy to Kubernetes") {
            steps {
                sh "sed -i \"s|image:.*|image: pareekaditya/gitxjenkins:${BUILD_NUMBER}|\" deployment.yml"
                sh "kubectl apply -f deployment.yml -f service.yml"
            }
        }

        stage("Verify Deployment") {
            steps {
                sh "kubectl rollout status deployment/simple-java-docker"
            }

            post {
                failure {
                    sh "kubectl rollout undo deployment/simple-java-docker"
                }
            }
        }

        stage("Application Test") {
            steps {
                sh "kubectl run test-client --rm -i --image=curlimages/curl -- curl --fail http://java-service:8080"
            }
        }

        stage("Record Deployment") {
            steps {
                sh "kubectl annotate deployment simple-java-docker kubernetes.io/change-cause=\"Jenkins build ${BUILD_NUMBER}\" --overwrite"
            }
        }
    }
}
