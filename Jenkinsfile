GITHUB_PIPELINE = "https://github.com/werdervg/start.git"
GITHUB_JOB1 = "https://github.com/werdervg/job1.git"
GITHUB_JOB2 = "https://github.com/werdervg/job2.git"
node{
    stage ("Listing Branches") 
      {
           echo "Initializing workflow"
            echo GITHUB_PIPELINE
			git url: GITHUB_PIPELINE
            sh 'git branch -r | awk \'{print $1}\' | cut -d \'/\' -f 2 >branch.txt && sed -i \'1iNONE\' branch.txt'
//				sh 'cut -d \'/\' -f 2 branches.txt>branch.txt'
//				sh 'sed -i \'1iNONE\' branch.txt'
            sh 'cat branch.txt'
			BRANCH_NAME = readFile 'branch.txt'
        }
}
pipeline {
agent none
  parameters {
    choice(
        name: 'BRANCHNAME',
        choices: "${BRANCH_NAME}  :",
        description: 'On this step you need select Branch for build' )
	}
   stages {
       stage('Check Preconditions') {
		agent {
			node {
				label 'master'
			}
		}
           when {
               expression { params.BRANCHNAME == 'NONE' }
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
                expression { params.BRANCHNAME == 'develop' }
            }
            steps {
				git branch: "$BRANCHNAME",url: GITHUB_JOB2
                sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }
        stage('Job On Mater with MASTER Branch') {
		agent {
			node {
				label 'master'
			}
		}
            when {
                expression { params.BRANCHNAME == 'master' }
            }
            steps {
				git branch: "$BRANCHNAME",url: GITHUB_JOB1
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*.sh" -exec chmod +x {} \\; -exec {} \\;'
            }
        }

	}
}
