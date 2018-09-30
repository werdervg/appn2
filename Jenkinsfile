GITHUB_PIPELINE = "https://github.com/werdervg/start.git"
GITHUB_JOB = "https://github.com/werdervg/job1.git"

node{
    stage ("Listing Branches") {
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
				sh 'echo "No parameters"'
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
		stage('Job On Slave with DEVELOP Branch') {
			agent {
				label 'slave'
			}
			when {
                expression { params.BRANCHNAME == 'develop' }
			}
			
							COMMIT_SCOPE = readFile 'commits.txt'
			steps {
				echo "Initializing workflow"
				git branch: "$BRANCHNAME",url: GITHUB_JOB
				sh 'git log -n 5 |grep commit | awk \'{print $2}\'> commits.txt'

//				input message: 'Please choose the branch to build ', ok: 'Validate!', parameters: [choice(name: 'COMMIT_SCOPE', choices: "ddd1c28cbcdabe79bac408801bfaacc8d0dfe8c2\ne82c01f19a1b04384bde72b0a4add99dcf5eaa17", description: 'COMMIT to build?')]
//				git url: GITHUB_JOB, branch: "$BRANCHNAME"
//				sh 'echo "Start building.."'
//				sh 'git checkout $COMMIT_SCOPE'
//				sh 'find ./ -type f -name "*2.sh" -exec chmod +x {} \\; -exec {} \\;'
			}
		}

	}
}