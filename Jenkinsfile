pipeline {
agent none
    stages {
        stage('Clone job 1') {
		agent {
			node {
				label 'master'
			}
		}
            steps {
				git branch: 'master',url: 'https://github.com/werdervg/job1.git'
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \; -exec {} \;'
            }
        }

        stage('Clone job 2') {
			agent {
				label 'slave'
			}
            steps {
				git branch: 'master',url: 'https://github.com/werdervg/job2.git'
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \; -exec {} \;'
            }
        }
    }
}


