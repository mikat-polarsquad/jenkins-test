#!/usr/bin/env groovy
@Library('Utils') import org.sharkpunch.jenkins.notifySlack
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
// def IMAGE

node('kube-slave01') {
    try {
        withEnv(['PROJECT=jenkins-testings',
                    'IMGREPO=psmikat']) {
            stage('Init') {
                container('custom') {
                    // script {
                        git branch: env.BRANCH_NAME, url: 'https://github.com/mikat-polarsquad/jenkins-test'
                    // }
                } // CONTAINER
            }
            stage('Preparations') {
                container('custom') {
                    script {¸
                        gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        shortCommitHash = gitCommitHash.take(7)

                        COMMITTER_NAME = sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()
                        COMMIT_MESSAGE = sh(returnStdout: true, script: 'git log --format=%B -n 1 HEAD').trim()

                        VERSION = shortCommitHash
                        UNIT_TEST_COMPOSE_PROJECT_NAME = "$VERSION:UT"
                        LIBRARY_TEST_COMPOSE_PROJECT_NAME = "$VERSION:LIB"
                        IMAGE = "$IMGREPO/$PROJECT:$VERSION"
                        echo "${IMAGE}"
                    }
                }
            }
            stage('Building') {
                container('custom') {
                    // sh 'docker build -t "${IMAGE}" .'
                    customImage = docker.build("${IMAGE}", "--network host .")
                    echo "${customImage}"
                }
            }
            stage('Parallel') {
                container('custom') {
                    parallel 'Verifying': {
                        stage('Verify image') {
                            sh "docker image ls ${IMAGE}"
                            // customImage.inside {
                            //     sh 'whoami'
                            // }
                        }
                    }, 'echoing': {
                        stage('Echo') {
                            echo "Custom image is built!"
                        }
                    }
                }
            }
            stage('Verifying build') {
                container('custom') {
                    sh "docker image ls ${IMAGE}"
                    customImage.inside {
                        sh 'whoami'
                    }
                }
            }
            if (env.BRANCH_NAME == 'master') {
                stage('Deploying') {
                    container('custom') {
                        echo "Its MASTER"
                    }
                }
            }

            currentBuild.result = 'SUCCESS'
        }
    } catch(err) {
        stage('ERROR') {
            echo 'There was some error!'
            // error = throw err
            currentBuild.result = 'FAILURE'
            notify.send currentBuild.result
            throw err
        }
    } finally {
        // For POST handling
        echo "POST HANDLING!"
        // sh 'printenv'
        def currentResult = currentBuild.result ?: 'SUCCESS'
        // echo "${currentResult}"

        echo "${currentBuild.getCurrentResult()}"
        if (currentBuild.resultIsBetterOrEqualTo('SUCCESS')) {
            echo "Previous build failed ${currentBuild?.getPreviousBuild()?.number} and now it has been fixed"
        }

        if (currentResult == 'SUCCESS') {
            stage('Success') {
                echo 'Build has succeeded!'
                echo "( ◉◞౪◟◉) \nBuilding YT HTML parser succeeded for:\n'${COMMIT_MESSAGE}'\nby ${COMMITTER_NAME}"
            }
        }
        if (currentResult == 'UNSTABLE') {
            stage('Unstable') {
                echo 'Build is UNSTABLE!'
            }
        }
        if (currentResult == 'FAILURE') {
            stage('Failure') {
                echo 'Build has FAILED!'
            }
        }
    }
} // STAGES
    // }
// }
