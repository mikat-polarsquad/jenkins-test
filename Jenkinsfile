// #!/usr/bin/env groovy
@Library('Utils') _ // import org.sharkpunch.jenkins.slack
def notifier = new org.sharkpunch.jenkins.slack.SlackNotifier()

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
    try {
      env.SLACK_CHANNEL = 'jenkins-testing'
      env.SLACK_DOMAIN  = 'matchmade.slack.com'
      env.CHANGE_LIST = 'true'
      // env.TEST_SUMMARY = 'true'
      env.NOTIFY_SUCCESS = 'true'

        withEnv(['PROJECT=jenkins-testings',
                    'IMGREPO=psmikat']) {
            stage('Init') {
                // container('custom') {
                    // script {
                        notifier.notifyStart()
                        git branch: 'testing-trigger', url: 'https://github.com/mikat-polarsquad/jenkins-test'
                    // }
                // } // CONTAINER
            }
            stage('Preparations') {
                // container('custom') {
                    script {
                        gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        shortCommitHash = gitCommitHash.take(7)

                        env.COMMITTER_NAME = sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()
                        env.COMMIT_MESSAGE = sh(returnStdout: true, script: 'git log --format=%B -n 1 HEAD').trim()

                        VERSION = shortCommitHash
                        UNIT_TEST_COMPOSE_PROJECT_NAME = "$VERSION:UT"
                        LIBRARY_TEST_COMPOSE_PROJECT_NAME = "$VERSION:LIB"
                        IMAGE = "$IMGREPO/$PROJECT:$VERSION"
                        echo "${IMAGE}"
                    }
                // } // container END
            }
            stage('Building') {
                // container('custom') {
                    // sh 'docker build -t "${IMAGE}" .'
                    customImage = docker.build("${IMAGE}", "--network host .")
                    echo "${customImage}"
                // } // container END
            }
            stage('Parallel') {
                // container('custom') {
                    parallel 'Verifying': {
                        stage('Verify image') {
                            sh "docker image ls ${IMAGE}"
                        }
                    }, 'echoing': {
                        stage('Echo') {
                            echo "Custom image is built!"
                        }
                    }
                // } // container END
            }
            stage('Verifying build') {
                // container('custom') {
                    sh "docker image ls ${IMAGE}"
                    // customImage.inside {
                    //     sh 'whoami'
                    // }

                // } // container END
            }
            if (env.BRANCH_NAME == 'master') {
                stage('Deploying') {
                    // container('custom') {
                        echo "Its MASTER"
                    // } // container END
                }
            }

            currentBuild.result = 'SUCCESS'
        }
    } catch(err) {
        // DONT PUT INSIDE STAGE. THEN IT WILL BE SHOWN AS IT'S OWN STAGE ON PIPELINE VISUAL!
            echo 'There was some error!'

            currentBuild.result = 'FAILURE'
            notifier.notifyError(err)

            // notify.send currentBuild.result
            throw err
    } finally {
        // For POST handling
        // THESE WILL BE EXECUTED ALLWAYS!

        if (currentBuild.result == 'SUCCESS') {
            stage('Success') {
                echo 'Build has succeeded!'
                notifier.notifyResult()
            }
        }
        if (currentBuild.result == 'UNSTABLE') {
            stage('Unstable') {
                echo 'Build is UNSTABLE!'
                notifier.notifyResult()
            }
        }
        if (currentBuild.result == 'FAILURE') {
            stage('Failure') {
                echo 'Build has FAILED!'
                notifier.notifyResult()
            }
        }
    } // Finally END
} // STAGES
    // }
// }
