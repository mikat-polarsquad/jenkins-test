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
// def echoStrings = ["eka", "toka", "kolmas", "neljas"]
// def echoesParallel = echoStrings.collectionEntries {
//     ["echoing ${it}" : transformIntoStep(it)]
// }
def builds = [:]
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
                sh 'curl https://google.com'
                // sh 'sleep 90'
            }
        } // CONTAINER
    }
    stage('Preparations') {
        container('custom') {
            script {
                gitCommitHash=sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                shortCommitHash=gitCommitHash.take(7)

                COMMITTER_NAME=sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()
                COMMIT_MESSAGE=sh(returnStdout: true, script: 'git log --format=%B -n 1 HEAD').trim()

                VERSION=shortCommitHash
                UNIT_TEST_COMPOSE_PROJECT_NAME="$VERSION:UT"
                LIBRARY_TEST_COMPOSE_PROJECT_NAME="$VERSION:LIB"
                IMAGE="$IMGREPO/$PROJECT:$VERSION"
                echo "${IMAGE}"
            }
        }
    }
    stage('Building') {
        container('custom') {
            echo "${IMAGE}"
            // sh 'docker build -t "${IMAGE}" .'
            def customImage = docker.build("${IMAGE}", "--network host .")
            echo "${customImage}"
        }
    }
    stage('Parallel') {
        parallel 'Verifying': {
            stage('Verify image') {
                sh "docker image ls"
            }
        }, 'echoing': {
            stage('Echo') {
                echo "Custom image is: ${customImage}"
            }
        }
    }
    stage('Verifying build') {
        container('custom') {
            sh "docker image ls"
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