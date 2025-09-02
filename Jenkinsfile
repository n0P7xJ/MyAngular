pipeline {
  agent any
  options { timestamps(); ansiColor('xterm') }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker image') {
      steps {
        // якщо є docker-compose.yml — викликає його
        // якщо ні — просто збирає образ напряму
        sh 'docker compose build || docker build -t angular-app:latest .'
      }
    }

    stage('Deploy') {
      steps {
        script {
          if (fileExists('docker-compose.yml')) {
            sh 'docker compose up -d'
          } else {
            sh '''
              docker rm -f angular-app || true
              docker run -d --name angular-app -p 8080:80 --restart always angular-app:latest
            '''
          }
        }
      }
    }
  }

  post {
    always {
      sh 'docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"'
    }
  }
}
