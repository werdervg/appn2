pipeline {
agent none
    stages {
        stage('Clone job 1') {
            steps {
				git url: 'https://github.com/werdervg/job1.git'
            }
        }
        stage('Building on master') {
			agent {
				label 'master'
			}
            steps {
                sh 'echo "Start building.."'
				sh 'chmod +x job1.sh'
				sh './job1.sh'
            }
        }
        stage('Clone job 2') {
			agent {
				label 'slave'
			}
            steps {
				git url: 'https://github.com/werdervg/job2.git'
            }
        }
        stage('Building on slave') {
			agent {
				label 'slave'
			}
            steps {
                sh 'echo "Start building.."'
				sh 'chmod +x job2.sh'
				sh './job2.sh'
            }
        }
    }
}


