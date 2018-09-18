pipeline {
agent none
    stages {
	if (env.PARAM_TEST == "Select1") { 
        stage('Clone job 1') {
		agent {
			node {
				label 'master'
			}
		}
            steps {
				git branch: 'master',credentialsId: '123123123',url: 'https://werdervg@github.com/werdervg/job1.git' 
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }
	}
	else {
        stage('Clone job 2') {
			agent {
				label 'slave'
			}
            steps {
				git branch: 'master',credentialsId: '123123123',url: 'https://werdervg@github.com/werdervg/job2.git'
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }
		}
        stage('ForTests') {
			agent {
				label 'slave'
			}
            steps {
				build("ForTests")
            }
        }
    }
}


                        
