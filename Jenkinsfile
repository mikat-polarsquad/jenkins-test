/**
 * This pipeline will run a Docker image build
 */

podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:1.11
    command: ['cat']
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
  ) {

  def image = "jenkins/jnlp-slave"
  node('kube-slave01') {
    stage("Init"){
        echo "Initializing build"
        git branch: 'testing-trigger', url: 'https://github.com/mikat-polarsquad/jenkins-test'
    }
    stage('Build Docker image') {
      git 'https://github.com/jenkinsci/docker-jnlp-slave.git'
      container('docker') {
        sh "docker build -t ${image} ."
      }
    }
    stage("The End"){
        sh 'docker ps'
    }
  }
}