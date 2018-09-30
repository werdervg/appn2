GITHUB_PIPELINE = "https://github.com/werdervg/start.git"
GITHUB_JOB = "https://github.com/werdervg/job1.git"
node{
    stage ("Listing Branches") 
      {
           echo "Initializing workflow"
            echo GITHUB_JOB
			git url: GITHUB_JOB
            sh 'git branch -r | awk \'{print $1}\' | cut -d \'/\' -f 2 >branch.txt && sed -i \'1iNONE\' branch.txt'
            sh 'cat branch.txt'
			BRANCH_NAME = readFile 'branch.txt'
        }
}

pipeline {
agent none
  parameters {
    choice(
        name: 'SELECT_BRANCH',
        choices: "${BRANCH_NAME}",
        description: 'Select Branch' )
	}
   stages {

       stage('Check Preconditions') {
		agent {
			node {
				label 'master'
			}
		}
           when {
               expression { params.SELECT_BRANCH == 'NONE' }
           }
           steps {
			sh 'echo "No parameters"'
			}
       }
        stage('Job On Slave with DEVELOP Branch') {
			agent {
				label 'slave'
			}
            when {
                expression { params.SELECT_BRANCH == 'develop' }
            }
            steps {
				git branch: "$SELECT_BRANCH",url: GITHUB_JOB
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*2.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }
        stage('Job On Mater with MASTER Branch') {
		agent {
			node {
				label 'master'
			}
		}
            when {
                expression { params.SELECT_BRANCH == 'master' }
            }
            steps {
				git branch: "$SELECT_BRANCH",url: GITHUB_JOB
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*1.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }

	}
}
