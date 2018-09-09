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