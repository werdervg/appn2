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
    stage ("Listing Commits") 
      {
           echo "Initializing workflow"
            echo GITHUB_JOB
			git url: GITHUB_JOB
			sh 'for i in `cat branch.txt`; do git checkout $i && git log -n 5 | grep commit | cut -d \' \' -f 2 > commits_$i.txt;done'	
        }
	stage('get build commits_ Parameter User Input') 
		{
			sh 'for i in `cat branch.txt`; do liste = readFile commits_$i.txt;done'
			echo "please click on the link here to chose the commits_ to build"
			input message: 'Please choose the commits_ to build ', ok: 'Validate!',
			parameters: [choice(name: 'COMMIN_NUMBER', choices: "${liste}", description: 'commit to build?')]
		}
}

pipeline {
agent none
  parameters {
    choice(
        name: 'BRANCHNAME : ',
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
