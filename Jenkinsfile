pipeline {
    agent {
        label 'kube-slave01'
    }

    // node('kube-slave01') {
        stages {
            stage('Build') {
                steps {
                    echo 'Building..'
                    sh 'sleep 5'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing ECR..'
                    sh 'docker image inspect 118224663706.dkr.ecr.eu-central-1.amazonaws.com/jenkins-blueocean:1.17.0'
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