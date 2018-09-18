pipeline {
agent none
  parameters {
    choice(
        name: 'myParameter',
        choices: "Option1\nOption2",
        description: 'interesting stuff' )
	}
    stages {
	
        stage('Clone job 1') {
		agent {
			node {
				label 'master'
			}
		}
            when {
                expression { params.myParameter == 'Option1' }
            }
            steps {
				git branch: 'master',credentialsId: '123123123',url: 'https://werdervg@github.com/werdervg/job1.git' 
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }

        stage('Clone job 2') {
			agent {
				label 'slave'
			}
            when {
                expression { params.myParameter == 'Option2' }
            }
            steps {
				git branch: 'master',credentialsId: '123123123',url: 'https://werdervg@github.com/werdervg/job2.git'
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
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
post { 
	success {
		node('master') {
		            deleteDir()

		}
	}
}
}
