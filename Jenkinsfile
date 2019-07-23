pipeline {
    agent {
        label 'kube-slave01'
    }

    // node('kube-slave01') {
        stages {
            stage('Build') {
                steps {
                    echo 'Building..'
                    sh 'sleep 30'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing ECR..'
                    sh 'aws ecr list-images --repository-name jenkins-blueocean'
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