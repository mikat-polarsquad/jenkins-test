
def label = "app-${UUID.randomUUID().toString()}".toString()

def databaseUsername = 'mysql'
def databasePassword = 'mysql'
def databaseName = 'test'
def databaseHost = '127.0.0.1'

// def jdbcUrl = "jdbc:mariadb://$databaseHost/$databaseName".toString()

// podTemplate(
//     cloud: "kubernetes",
//     containers: [
//     // containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
//     // containerTemplate(
//     //   name: 'golang',
//     //   image: 'golang:1.8.0',
//     //   ttyEnabled: true,
//     //   command: 'cat'),
//     containerTemplate(
//       name: 'mysql',
//       image: 'mysql:5',
//       ttyEnabled: true,
//       command: 'cat',
//       envVars: [
//         envVar(key: 'MYSQL_DATABASE', value: databaseName),
//         envVar(key: 'MYSQL_USER', value: databaseUsername),
//         envVar(key: 'MYSQL_PASSWORD', value: databasePassword),
//         envVar(key: 'MYSQL_ALLOW_EMPTY_PASSWORD', value: "yes")
//         // envVar(key: 'MYSQL_ROOT_PASSWORD', value: "kurko")
//       ]),
//     containerTemplate(
//       name: 'mariadb',
//       image: 'mariadb',
//       ttyEnabled: true,
//       command: 'cat',
//       envVars: [
//         envVar(key: 'DB_NAME', value: databaseName),
//         envVar(key: 'DB_USER', value: databaseUsername),
//         envVar(key: 'DB_PASSWORD', value: databasePassword),
//         envVar(key: 'DB_ROOT_PASSWORD', value: "kurko")
//       ])
podTemplate(
  label: 'kube-podi',
  cloud: 'kubernetes', //This needs to match the cloud name in jenkins-kubernetes-plugin config
  containers: [
    //Jenkins agent. Also executes the integration test. Having a 'jnlp' container is mandatory.
    // containerTemplate(name: 'jnlp',
    //                   image: 'registry.access.redhat.com/openshift3/jenkins-slave-maven-rhel7:v3.9',
    //                   resourceLimitMemory: '512Mi',
    //                   args: '${computer.jnlpmac} ${computer.name}',
    //                   envVars: [
    //                     //Heap for mvn and surefire process is 1/4 of resourceLimitMemory by default
    //                     envVar(key: 'JNLP_MAX_HEAP_UPPER_BOUND_MB', value: '64')
    //                   ]),
    // //App under test
    // containerTemplate(name: 'app-users',
    //                   image: '172.30.1.1:5000/myproject/app-users:latest',
    //                   resourceLimitMemory: '512Mi',
    //                   envVars: [
    //                     envVar(key: 'SPRING_PROFILES_ACTIVE', value: 'k8sit'),
    //                     envVar(key: 'SPRING_CLOUD_KUBERNETES_ENABLED', value: 'false')
    //                   ]),
    //DB
    containerTemplate(name: 'mariadb',
                      image: 'mariadb',
                      resourceLimitMemory: '256Mi',
                      envVars: [
                        envVar(key: 'MYSQL_USER', value: 'myuser'),
                        envVar(key: 'MYSQL_PASSWORD', value: 'mypassword'),
                        envVar(key: 'MYSQL_DATABASE', value: 'testdb'),
                        envVar(key: 'MYSQL_ROOT_PASSWORD', value: 'secret')
                      ]),
      volumes: [
        hostPathVolume(mountPath: "/var/run/docker.sock", hostPath: "/var/run/docker.sock")
      ]
  ]) {

    node('kube-podi') {
      stage('DB Init') {
        container('mysql') {
          sh "printenv"
          sh "hostname"
          sh "sleep 10"
          def isItReady = sh (
                        script: "while ! /usr/bin/mysqladmin ping -hlocalhost --silent; do sleep 1; done",
                        returnStdout: true
                      )
          echo "${isItReady}"
        }
      }


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


    }
}