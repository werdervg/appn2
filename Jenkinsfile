GITHUB_PROJECT = "https://github.com/werdervg/start.git"
GITHUB_BRANCH = '${env.BRANCH_NAME}'
node{
    stage ("Listing Branches") 
      {
           echo "Initializing workflow"
            echo GITHUB_PROJECT
           git url: GITHUB_PROJECT
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
        stage('Check Preconditions') {
		agent {
			node {
				label 'master'
			}
		}
            when {
                expression { params.myParameter == 'NULL' }
            }
		
		currentBuild.result = 'SUCCESS'
		return
		
        }
        stage('Job On Mater with MASTER Branch') {
		agent {
			node {
				label 'master'
			}
		}
            when {
                expression { params.myParameter == 'master' }
            }
            steps {
				git branch: '$myParameter',url: 'https://werdervg@github.com/werdervg/job1.git' 
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }

        stage('Job On Slave with DEVELOP Branch') {
			agent {
				label 'slave'
			}
            when {
                expression { params.myParameter == 'develop' }
            }
            steps {
				git branch: '$myParameter',url: 'https://werdervg@github.com/werdervg/job2.git'
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }
	}
}
