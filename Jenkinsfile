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
        name: 'BRANCHNAME',
        choices: "${BRANCH_NAME}",
        description: 'On this step you need select Branch for build' )
	}
   stages {
//	stage ("Listing Commits") {
//		agent {
//			node {
//				label 'master'
//			}
//		}
//		steps {
//			echo "Initializing workflow"
//			echo GITHUB_JOB
//			echo "$BRANCHNAME"
//			git branch: "$BRANCHNAME",url: GITHUB_JOB
//			sh 'git log -n 5 |grep commit | awk \'{print $2}\'> commits.txt'
//			sh 'cat commits.txt'
//		}
//	}
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
				input message: 'Please choose the branch to build ', ok: 'Validate!', parameters: [choice(name: 'COMMIT_SCOPE', choices: "Par1\nPar2", description: 'COMMIT to build?')]
				sh 'echo "No parameters""$COMMITSCOPE"'
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
				echo "Initializing workflow"
				echo GITHUB_JOB
				echo "$BRANCHNAME"
				git branch: "$BRANCHNAME",url: GITHUB_JOB
				sh 'git log -n 5 |grep commit | awk \'{print $2}\'> commits.txt'
				sh 'cat commits.txt'
				COMMITSCOPE = readFile 'commits.txt'
				input message: 'Please choose the branch to build ', ok: 'Validate!', parameters: [choice(name: 'COMMIT_SCOPE', choices: "$COMMITSCOPE", description: 'COMMIT to build?')]
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
				expression { params.BRANCHNAME == 'master' }
			}
			steps {
				echo "Initializing workflow"
				echo GITHUB_JOB
				echo "$BRANCHNAME"
				git branch: "$BRANCHNAME",url: GITHUB_JOB
				sh 'git log -n 5 |grep commit | awk \'{print $2}\'> commits.txt'
				sh 'cat commits.txt'
				sh 'echo "Start building.."'
				sh 'find ./ -type f -name "*1.sh" -exec chmod +x {} \\; -exec {} \\;'
			}
		}
	}
}