// #!/usr/bin/groovy
// pipeline {
//     agent any
    //     node { label 'kube-slave01' }
    // }

    // stages {
node('kube-slave01') {
    // withEnv(['ENVIRONMENT=test',
    //      'PROJ=jenkins-test'])
    stage('Build') {
        container('custom') {
            // steps {
                echo 'Building..'
                sh 'hostname'
                sh 'echo $ENVIRONMENT'
                sh 'echo $PROJ'
                sh 'docker --version'
                sh 'sleep 5'
            // }
        } // CONTAINER
    }
} // STAGES
    // }
// }