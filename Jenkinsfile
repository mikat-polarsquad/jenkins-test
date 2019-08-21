
def label = "app-${UUID.randomUUID().toString()}".toString()

def databaseUsername = 'mysql'
def databasePassword = 'mysql'
def databaseName = 'test'
def databaseHost = '127.0.0.1'

// def jdbcUrl = "jdbc:mariadb://$databaseHost/$databaseName".toString()

podTemplate(
    cloud: "kubernetes",
    containers: [
    containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
    containerTemplate(
      name: 'golang',
      image: 'golang:1.8.0',
      ttyEnabled: true,
      command: 'cat'),
    containerTemplate(
      name: 'mariadb',
      image: 'mariadb',
      ttyEnabled: true,
      command: 'cat',
      envVars: [
        envVar(key: 'MYSQL_DATABASE', value: databaseName),
        envVar(key: 'MYSQL_USER', value: databaseUsername),
        envVar(key: 'MYSQL_PASSWORD', value: databasePassword),
        envVar(key: 'MYSQL_ROOT_PASSWORD', value: "kurko")
      ]),
    containerTemplate(
      name: 'mysql',
      image: 'mysql:5.6',
      ttyEnabled: true,
      command: 'cat',
      envVars: [
        envVar(key: 'MYSQL_DATABASE', value: databaseName),
        envVar(key: 'MYSQL_USER', value: databaseUsername),
        envVar(key: 'MYSQL_PASSWORD', value: databasePassword),
        envVar(key: 'MYSQL_ROOT_PASSWORD', value: "kurko")
      ])
  ]) {

    node(POD_LABEL) {
      stage('Get a Maven project') {
          git 'https://github.com/jenkinsci/kubernetes-plugin.git'
          container('maven') {
              stage('Build a Maven project') {
                  sh 'mvn -B clean install'
              }
          }
      }

      stage('Get a Golang project') {
          git url: 'https://github.com/hashicorp/terraform.git'
          container('golang') {
              stage('Build a Go project') {
                  sh """
                  mkdir -p /go/src/github.com/hashicorp
                  ln -s `pwd` /go/src/github.com/hashicorp/terraform
                  cd /go/src/github.com/hashicorp/terraform && make core-dev
                  """
              }
          }
      }

      stage('DB Init') {
        container('mariadb') {
          def isItReady = sh (
                        script: "while ! /usr/bin/mysqladmin ping -hdb --silent; do sleep 1; done",
                        returnStdout: true
                      )
          echo "${isItReady}"
        }
      }

    }
}