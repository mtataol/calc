pipeline {
    agent any
    stages {
        stage("Checkout") {
            steps {
                git url: 'https://github.com/mtataol/calc.git'
           }
        }
        stage("Compile") {
            steps {
                sh "./gradlew compileJava"
            }
        }
        stage("Unit test") {
            steps {
                sh "./gradlew test"
            }
        }
        stage("Code coverage") {
            steps {
                sh "./gradlew jacocoTestReport"
                publishHTML (target: [
                    reportDir: 'build/reports/jacoco/test/html',
                    reportFiles: 'index.html',
                    reportName: "JaCoCo Report"
                ])
                sh "./gradlew jacocoTestCoverageVerification"
            }
        }
        stage("Static code analysis") {
            steps {
                sh "./gradlew checkstyleMain"
                publishHTML (target: [
                    reportDir: 'build/reports/checkstyle/',
                    reportFiles: 'main.html',
                    reportName: "Checkstyle Report"
                ])
            }
        }
        stage("Package") {
            steps {
                sh "./gradlew build"
            }
        }
        stage("Docker build") {
            steps {
                sh "docker build -t mtataol/calculator ."
            }
        }
        stage("Docker push") {
            steps {
                sh "docker push mtataol/calculator"
            }
        }
        stage("Deploy") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'tamerspc', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    sh "sshpass -p $pass ssh -o StrictHostKeyChecking=no tamer@192.168.1.39 docker run -d --name auto-deployed mtataol/calculator"
                }
            }
        }
    }
    post {
        always {
            mail to: 'jenkins@tamerataol.com',
            subject: "Completed Pipeline: ${currentBuild.fullDisplayName}",
            body: "Your build completed, please check: ${env.BUILD_URL}"
        }
    }
}