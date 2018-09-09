pipeline {
agent {
	label 'master'
}
    stages {
        stage('Clone job 1') {
            steps {
				git url: 'https://github.com/werdervg/job1.git'
            }
        }
        stage('Building..') {
            steps {
                sh 'echo "Start building.."'
				sh 'chmod +x job1.sh'
				sh './job1.sh'
            }
        }
    }
}
pipeline {
agent {
	label 'slave'
}
    stages {
        stage('Clone job 2') {
            steps {
				git url: 'https://github.com/werdervg/job2.git'
            }
        }
        stage('Building..') {
            steps {
                sh 'echo "Start building.."'
				sh 'chmod +x job2.sh'
				sh './job2.sh'
            }
        }
    }
}