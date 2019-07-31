#!/usr/bin/groovy
pipeline {
    agent {
        node { label 'kube-slave01' }
    }

    // node('kube-slave01') {
        stages {
            stage('Build') {
                // container('custom') {
                    steps {
                        echo 'Building..'
                        sh 'hostname'
                        sh 'sleep 5'
                    }
                // } // CONTAINER
            }
            // stage('Test') {
            //     steps {
            //         echo 'Testing ECR..'
            //         sh 'pwd'
            //         // sh 'docker --version'
            //         // sh 'aws ecr list-images --repository-name jenkins-blueocean'
            //     }
            // }
            // stage('Deploy') {
            //     steps {
            //         echo 'Time to inspect the running container...'
            //         sh 'printenv'
            //         sh 'sleep 600'
            //         // sh 'docker --version'
            //         // sh 'aws ecr list-images --repository-name jenkins-blueocean'
            //     }
            // }
            // stage('Deploy') {
            //     steps {
            //         echo 'Deploying....'
            //         sh 'sleep 30'
            //     }
            // }
        } // STAGES
    }
// }