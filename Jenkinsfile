// #!/usr/bin/groovy
// pipeline {
//     agent any
    //     node { label 'kube-slave01' }
    // }

    // stages {
node('kube-slave01') {
            stage('Build') {
                container('custom') {
    withEnv(['ENVIRONMENT=test',
         'PROJ=jenkins-test',
         'IMAGE=psmikat/jnlp-slave:test']) {
                    // steps {
                        echo 'Building..'
                        sh 'hostname'
                        sh 'echo $ENVIRONMENT'
                        sh 'echo $PROJ'
                        sh 'docker pull $IMAGE'
                        sh 'docker image ls'
                        sh 'sleep 5'
                    // }
                } // CONTAINER
            }
         }
} // STAGES
    // }
// }