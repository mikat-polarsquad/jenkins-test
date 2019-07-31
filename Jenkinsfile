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
                                // sh 'printenv'
                                // sh 'echo $(BRANCH_NAME)'
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
    if (env.BRACH_NAME == 'master') {
        stage('Deploying') {
            sh 'echo It"s MASTER'
        }
    } else {
        stage('Devving') {
            sh 'echo $BRACH_NAME'
        }
    }
} // STAGES
    // }
// }