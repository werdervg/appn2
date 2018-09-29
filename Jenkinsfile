GITHUB_PROJECT = "https://github.com/werdervg/start.git"
GITHUB_CREDENTIALS_ID = "werdervg"
APPLICATION_NAME = "BKbqAhPfMOTInQ3fs1hi"
GITHUB_BRANCH = '${env.BRANCH_NAME}'
node{
    stage ("Listing Branches") 
      {
           echo "Initializing workflow"
            echo GITHUB_PROJECT
           git url: GITHUB_PROJECT, credentialsId: GITHUB_CREDENTIALS_ID
            sh 'git branch -r | awk \'{print $1}\' >branches.txt'
            sh 'cut -d \'/\' -f 2 branches.txt>branch.txt'
            sh 'cat branch.txt'
			liste = readFile 'branch.txt'
        }
}
pipeline {
agent none
  parameters {
    choice(
        name: 'myParameter',
        choices: "${liste}",
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
		node('slave') {
			deleteDir()
		}
	}

}
}
