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
                    sh 'docker build -t devops-integration .'
                    sh 'docker save -o ./devops-integration.tar devops-integration'
                }
            }
        }
        stage ('mkdir tmp dir && copy image startup.sh') {
            steps {
                script {
                    if (fileExists('./devops-integration/')) {
                        fileOperations([folderDeleteOperation('./devops-integration/')])
                    }
                    fileOperations([folderCreateOperation('./devops-integration/')])
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: false, includes: 'startup.sh,**/*.tar', renameFiles: false, sourceCaptureExpression: '', targetLocation: './devops-integration/', targetNameExpression: '')])
                }
            }
        }
        stage('push image to local area network && startup docker container'){
            steps{
                script{
                    sshPublisher(publishers: [sshPublisherDesc(configName: '192.168.100.184', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''cd /root/images/devops-integration/
                    sh ./startup.sh''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/devops-integration/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }
            }
        }
        // stage('Push image to Hub'){
        //     steps{
        //         script{
        //           withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
        //                 sh 'docker login -u ywxkhpt -p ${dockerhubpwd}'
        //             }
        //           sh 'docker push ywxkhpt/devops-integration'
        //         }
        //     }
        // }
    }
}