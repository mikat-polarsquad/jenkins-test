pipeline {
    agent {
        label 'kube-slave02'
    }

    // node('kube-slave01') {
        stages {
            stage('Build') {
                steps {
                    echo 'Building..'
                    sh 'sleep 600'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing ECR..'
                    sh 'pwd'
                    sh 'docker --version'
                    // sh 'aws ecr list-images --repository-name jenkins-blueocean'
                }
            }
            // stage('Deploy') {
            //     steps {
            //         echo 'Deploying....'
            //         sh 'sleep 30'
            //     }
            // }
        }
    // }
}