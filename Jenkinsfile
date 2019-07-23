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
                    echo 'Testing..'
                    sh 'sleep 30'
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