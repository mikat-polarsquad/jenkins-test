#!/usr/bin/groovy
pipeline {
    agent any
    //     node { label 'kube-slave01' }
    // }

    node('kube-slave01') {
        stages {
            stage('Build') {
                // container('custom') {
                    steps {
                        echo 'Building..'
                        sh 'hostname'
                        sh 'docker --version'
                        sh 'sleep 5'
                    }
                // } // CONTAINER
            }
        } // STAGES
    }
}