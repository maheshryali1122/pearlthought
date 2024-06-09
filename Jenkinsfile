pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'nodejsv12'
    }
    environment {
        SCANNER_HOME=tool 'sonarscanner'
    }
    triggers { pollSCM('* * * * *') }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('clone_the_code') {
            steps {
                git branch: 'master',
                       url: 'https://github.com/maheshryali/example-app-nodejs-backend-react-frontend.git'
            }
        }
        stage('sonar_scan') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=examplenodejs \
                    -Dsonar.projectKey=examplenodejs '''
                }
            }
        }
        stage('Quality_gate') {
            steps {
                script {
                    *waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Docker_build_push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh """
                        docker image build -t nodejs:${BUILD_ID} .
                        docker tag nodejs:${BUILD_ID} maheshryali/nodejs:${BUILD_ID}
                        docker image push maheshryali/nodejs:${BUILD_ID}
                        """
                    }
                }
            }
        }
        stage('Trivy_scan') {
            steps {
                sh "trivy image maheshryali/nodejs:${BUILD_ID} > trivyimage.txt"
            }
        }
        stage('Deploy_application_to_k8s') {
            steps {
                script {
                    dir('kubernetes') {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                            sh """
                            kubectl apply -f deployment.yaml
                            kubectl apply -f service.yaml
                            """
                        }
                    }
                }
            }
        }
    }
}
