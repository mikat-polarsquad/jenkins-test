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
    withEnv(['PROJECT=jenkins-testings']) {
    stage('Init') {
        container('custom') {
            script {
                echo 'Building..'
                // sh 'printenv'
                sh 'echo $BRANCH_NAME'
                git 'https://github.com/mikat-polarsquad/jenkins-test'
                sh 'git status'
                sh 'ls -la'
            }
        } // CONTAINER
    }
    stage('Preparations') {
        container('custom') {
            withEnv(['PROJECT=jenkins-test',
                     'IMGREPO=psmikat']) {
                        script {
                            gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                            shortCommitHash = gitCommitHash.take(7)

                            COMMITTER_NAME = sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()
                            COMMIT_MESSAGE = sh(returnStdout: true, script: 'git log --format=%B -n 1 HEAD').trim()

                            VERSION = shortCommitHash
                            UNIT_TEST_COMPOSE_PROJECT_NAME = "$VERSION:UT"
                            LIBRARY_TEST_COMPOSE_PROJECT_NAME = "$VERSION:LIB"
                            IMAGE = "$IMGREPO/$PROJECT:$VERSION"
                            sh 'echo $PROJECT'
                        }
            } // CONTAINER
        }
    }
    if (currentBuild.currentResult == 'SUCCESS') {
        stage('Finish it') {
            sh 'echo $PROJECT'
        }
    }
    if (env.BRANCH_NAME == 'master') {
        stage('Deploying') {
            sh 'echo It"s MASTER'
        }
    } else {
        stage('Devving') {
            sh 'echo $BRANCH_NAME'
        }
    }
    }
} // STAGES
    // }
// }