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
def IMAGE
node('kube-slave01') {
    withEnv(['PROJECT=jenkins-testings',
                'IMGREPO=psmikat']) {
    stage('Init') {
        container('custom') {
            script {
                echo 'Building..'
                // sh 'printenv'
                echo "${IMAGE}"
                git branch: 'testing-trigger', url: 'https://github.com/mikat-polarsquad/jenkins-test'
                sh 'git status'
                sh 'ls -la'
            }
        } // CONTAINER
    }
    stage('Preparations') {
        container('custom') {
            // script {
                gitCommitHash=sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                shortCommitHash=gitCommitHash.take(7)

                COMMITTER_NAME=sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()
                COMMIT_MESSAGE=sh(returnStdout: true, script: 'git log --format=%B -n 1 HEAD').trim()

                VERSION=shortCommitHash
                UNIT_TEST_COMPOSE_PROJECT_NAME="$VERSION:UT"
                LIBRARY_TEST_COMPOSE_PROJECT_NAME="$VERSION:LIB"
                IMAGE="$IMGREPO/$PROJECT:$VERSION"
                echo "${IMAGE}"
            // }
        }
    }
    stage('Building') {
        container('custom') {
            echo "${IMAGE}"
            sh 'docker build -t ${IMAGE} .'
            // docker.build()
        }
    }
    stage('Verifying build') {
        container('custom') {
            sh 'echo "Verifying build... && docker image ls"'
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