
def label = "app-${UUID.randomUUID().toString()}".toString()

def databaseUsername = 'mysql'
def databasePassword = 'mysql'
def databaseName = 'test'
def databaseHost = '127.0.0.1'

// def jdbcUrl = "jdbc:mariadb://$databaseHost/$databaseName".toString()

podTemplate(yaml:"""
apiVersion: v1
kind: Pod
metadata:
  name: jnlp-slave
  namespace: jenkins
  labels:
    nodegroup: jenkins-slave
spec:
  serviceAccountName: sa-jenkins
  containers:
  - name: mysql
    image: mysql:5
    tty: true
    env:
      - name: MYSQL_DATABASE
        value: ${databaseName}
      - name: MYSQL_USER
        value: ${databaseUsername}
      - name: MYSQL_PASSWORD
        value: ${databasePassword}
      - name: MYSQL_ALLOW_EMPTY_PASSWORD
        value: yes
  - name: docker
    image: docker
    tty: true
    command: ['cat']
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
    // cloud: 'kubernetes',
    // nodeSelector: 'nodegroup:jenkins-slave',
    // namespace: 'jenkins',
    // serviceAccount: 'sa-jenkins',
    // containers: [
    // // containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
    // // containerTemplate(
    // //   name: 'golang',
    // //   image: 'golang:1.8.0',
    // //   ttyEnabled: true,
    // //   command: 'cat'),
    // containerTemplate(
    //   name: 'mysql',
    //   image: 'mysql:5',
    //   ttyEnabled: true,
    //   // command: 'cat',
    //   envVars: [
    //     envVar(key: 'MYSQL_DATABASE', value: databaseName),
    //     envVar(key: 'MYSQL_USER', value: databaseUsername),
    //     envVar(key: 'MYSQL_PASSWORD', value: databasePassword),
    //     envVar(key: 'MYSQL_ALLOW_EMPTY_PASSWORD', value: "yes")
    //     // envVar(key: 'MYSQL_ROOT_PASSWORD', value: "kurko")
    //   ]),
    // containerTemplate(
    //   name: 'centos',
    //   image: 'centos',
    //   ttyEnabled: true,
    //   command: 'cat',
    //   envVars: [
    //     envVar(key: 'DB_NAME', value: databaseName),
    //     envVar(key: 'DB_USER', value: databaseUsername),
    //     envVar(key: 'DB_PASSWORD', value: databasePassword),
    //     envVar(key: 'DB_ROOT_PASSWORD', value: "kurko")
    //   ]),
    // containerTemplate(
    //   name: 'docker',
    //   image: 'docker',
    //   ttyEnabled: true,
    //   command: 'cat',
    //   envVars: [
    //     envVar(key: 'DB_NAME', value: databaseName),
    //     envVar(key: 'DB_USER', value: databaseUsername),
    //     envVar(key: 'DB_PASSWORD', value: databasePassword),
    //     envVar(key: 'DB_ROOT_PASSWORD', value: "kurko")
    //   ]),
    //   // ] // Containers END
    //   ],
    //   volumes: [
    //     hostPathVolume(mountPath: "/var/run/docker.sock", hostPath: "/var/run/docker.sock")
    //   ]
      ) {

    node(POD_LABEL) {
      stage('DB Init') {
        container('mysql') {
          sh "printenv"
          DB_HOST = sh (
                        script: "hostname",
                        returnStdout: true
                      )
          echo "${DB_HOST}"
          // sh "sleep 10"
          def isItReady = sh (
                        script: "while ! /usr/bin/mysqladmin ping -hlocalhost --silent; do sleep 1; done",
                        returnStdout: true
                      )
          echo "${isItReady}"
        }
      }


      // stage('DB Conn') {
      //   container('centos') {
      //     sh "printenv"
      //     sh "yum install -y mysql"
      //     // sh "sleep 10"
      //     def ready = sh (
      //                   script: "while ! /usr/bin/mysqladmin ping -h ${databaseHost} -u ${databaseUsername} --password=${databasePassword} --silent; do sleep 1; done",
      //                   returnStdout: true
      //                 )
      //     echo "${ready}"
      //   }
      //   containerLog 'mysql'
      //   containerLog 'centos'
      // }
      
      
      stage('Docker') {
        container('docker') {
          sh "printenv"
          sh "docker ps"
          // docker.image('centos').inside("-e DB_HOST=${databaseHost}",
          //                                 "-e DB_USER=${databaseUsername}",
          //                                 "-e DB_PASSWORD=${databasePassword}") { c ->
          docker.image('centos').inside("--network host") {
            sh "hostname"
            // sh "sleep 10"
            sh "yum install -y mysql"
            sh "mysqladmin ping -h ${DB_HOST}"
          }
          sh "sleep 80"
        }
        containerLog 'docker'
      }

      // stage('Get a Maven project') {
      //     git 'https://github.com/jenkinsci/kubernetes-plugin.git'
      //     container('maven') {
      //         stage('Build a Maven project') {
      //             sh 'mvn -B clean install'
      //         }
      //     }
      // }


      // stage('Get a Golang project') {
      //     git url: 'https://github.com/hashicorp/terraform.git'
      //     container('golang') {
      //         stage('Build a Go project') {
      //             sh """
      //             mkdir -p /go/src/github.com/hashicorp
      //             ln -s `pwd` /go/src/github.com/hashicorp/terraform
      //             cd /go/src/github.com/hashicorp/terraform && make core-dev
      //             """
      //         }
      //     }
      // }


    }
}