// #!/usr/bin/env groovy
@Library('Utils') _ // import org.sharkpunch.jenkins.slack
def notifier = new org.sharkpunch.jenkins.slack.SlackNotifier()

def label = "app-${UUID.randomUUID().toString()}".toString()

def databaseUsername = 'mysql'
def databasePassword = 'mysql'
def databaseName = 'test'
def databaseHost = '127.0.0.1'

def jdbcUrl = "jdbc:mariadb://$databaseHost/$databaseName".toString()

podTemplate(
        label: kube,
        cloud: kubermnetes,
        containers: [
                // containerTemplate(
                //         name: 'jdk',
                //         image: 'openjdk:8-jdk-alpine',
                //         ttyEnabled: true,
                //         command: 'cat',
                //         envVars: [
                //                 envVar(key: 'JDBC_URL', value: jdbcUrl),
                //                 envVar(key: 'JDBC_USERNAME', value: databaseUsername),
                //                 envVar(key: 'JDBC_PASSWORD', value: databasePassword),
                //         ]
                // ),
                containerTemplate(
                        name: "mariadb",
                        image: "mariadb",
                        envVars: [
                                envVar(key: 'MYSQL_DATABASE', value: databaseName),
                                envVar(key: 'MYSQL_USER', value: databaseUsername),
                                envVar(key: 'MYSQL_PASSWORD', value: databasePassword),
                                envVar(key: 'MYSQL_ALLOW_EMPTY_PASSWORD', value: yes),
                                envVar(key: 'MYSQL_ROOT_PASSWORD', value: databasePassword)
                        ],
                ),
                containerTemplate(
                    name: "centos",
                    image: "centos:7",
                    tty: true,
                    command: 'cat',
                    envVars: [
                      envVar(key: "DB_NAME", value: databaseName),
                      envVar(key: "DB_USER", value: databaseUser),
                      envVar(key: "DB_PASS", value: databasePassword),
                      envVar(key: "DB_HOST", value: databaseHost)
                    ]
                )
        ]
) {
  node(kube) {

      // stage('Checkout'){
      //     checkout scm
      // }

      stage('Waiting for environment to start') {
          container('mariadb') {
              sh """
                while ! mysqladmin ping --user=$databaseUsername --password=$databasePassword -h$databaseHost --port=3306 --silent; do
                    sleep 1
                done
                """
          }

      }

      stage('Migrate database') {
          container('centos') {
              sh 'printenv'
              sh 'yum install -y mysql'
              // sh './gradlew flywayMigrate -i'
          }
      }

      stage('Run Tests') {
          container('centos') {
              sh 'echo Jippii!'
              // sh './gradlew test'
          }
      }
  }
}