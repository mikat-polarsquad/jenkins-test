// #!/usr/bin/groovy
properties(
    [
        buildDiscarder(
            logRotator(
                daysToKeepStr: '7',
                numToKeepStr: '25'
            )
        )
    ]
)
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
                            // }
            } // CONTAINER
        }
    }
    if (currentBuild.currentResult == 'SUCCESS') {
        stage('Finish it') {
            sh 'echo "Everyting OK!"'
        }
    }
} // STAGES
    // }
// }