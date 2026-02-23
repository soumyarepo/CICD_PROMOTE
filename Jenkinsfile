pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  parameters {
    choice(name: 'TARGET', choices: ['AUTO', 'DEV', 'QA', 'UAT', 'PROD'],
           description: 'AUTO = Dev auto on webhook. Manual run can deploy to specific env.')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build') {
      steps {
        sh 'mkdir -p artifact && cp index.html artifact/'
        echo "Build done ✅"
      }
    }

    stage('Unit Test (Dummy)') {
      steps { echo "Dummy tests passed ✅" }
    }

    stage('Deploy DEV (Auto)') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'DEV' }
        }
      }
      steps {
        sh 'sudo bash deploy.sh DEV ${BUILD_NUMBER}'
      }
    }

    stage('Approve QA') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'QA' }
        }
      }
      steps { input message: "Approve promotion to QA?", ok: "Promote to QA" }
    }

    stage('Deploy QA') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'QA' }
        }
      }
      steps { sh 'sudo bash deploy.sh QA ${BUILD_NUMBER}' }
    }

    stage('Approve UAT') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'UAT' }
        }
      }
      steps { input message: "Approve promotion to UAT?", ok: "Promote to UAT" }
    }

    stage('Deploy UAT') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'UAT' }
        }
      }
      steps { sh 'sudo bash deploy.sh UAT ${BUILD_NUMBER}' }
    }

    stage('Approve PROD') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'PROD' }
        }
      }
      steps { input message: "Final approval for PROD?", ok: "Deploy PROD" }
    }

    stage('Deploy PROD') {
      when {
        anyOf {
          expression { params.TARGET == 'AUTO' }
          expression { params.TARGET == 'PROD' }
        }
      }
      steps { sh 'sudo bash deploy.sh PROD ${BUILD_NUMBER}' }
    }
  }

  post {
    success { echo "✅ Pipeline success" }
    failure { echo "❌ Pipeline failed" }
  }
}