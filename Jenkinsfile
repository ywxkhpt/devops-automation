pipeline {
    agent any
    tools{
        maven 'Maven-3.9.4'
    }
    stages{
        stage('Build Maven'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ywxkhpt/devops-automation']])
                sh 'mvn clean install'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker rmi ywxkhpt/devops-integration'
                    sh 'docker build -t ywxkhpt/devops-integration .'
                }
            }
        }
        stage('Push image to Hub'){
            steps{
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                        sh 'docker login -u ywxkhpt -p ${dockerhubpwd}'
                    }
                   sh 'docker push ywxkhpt/devops-integration'
                }
            }
        }
    }
}