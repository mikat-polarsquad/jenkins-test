pipeline {
    agent {
        label 'kube-slave01'
    }

    // node('kube-slave01') {
        stages {
            stage('Build') {
                steps {
                    echo 'Building..'
                    sh 'sleep 120'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing ECR..'
                    sh 'pwd'
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