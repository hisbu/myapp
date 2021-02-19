pipeline {
  agent any
  environment {
    CI = 'true'
    DOCKER_TAG = getDockerTag()
  }

  stages {
    stage ('Install Dependencies react project') {
      steps {
        echo 'Start install dependencies react project'
        sh 'npm install'
      }
    }
    stage('Test project'){
      steps {
        // sh './jenkins/scripts/test.sh'
        echo "unit testing"
      }
    }
    stage('Build Project react'){
      steps{
        sh 'npm run build'
      }
    }
    stage ('Build Docker Image'){
      steps {
        script {
          app=docker.build("hisbu/project-myapp")
        }
      }
    }
    stage ('Test docker image'){
      steps {
        sh 'docker run -d --rm --name testImages -p 8088:80 hisbu/project-myapp'
        input message: "Selesai test docker image? (Click procced to continue!)"
      }
    }
    stage ('Clean updocker test'){
      steps {
        sh 'docker stop testImages'
      }
    }
    stage ('push imate to registry'){
      steps {
        script{
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub'){
            app.push("${DOCKER_TAG}")
            app.push("latest")
          }
        }
      }
    }
    stage ('celan up image'){
      steps {
        sh 'docker rmi hisbu/project-myapp'
      }
    }
    stage('Apply Kubernetes files') {
        steps{
          sh "chmod +x changeTag.sh"
          sh "./changeTag.sh ${DOCKER_TAG}"
          withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://35.184.41.38']) {
            sh 'kubectl apply -f reactapp-config.k8s.yaml'
          }
        }
    }
  }
}

def getDockerTag(){
  def tag = sh script: "git rev-parse HEAD", returnStdout: true
  return tag
}