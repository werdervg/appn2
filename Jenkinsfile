pipeline {
    agent {
		label 'master'
		}
	stages {
		stage('Clone job 1') {
				steps {
					url: 'https://github.com/werdervg/job2.git'
				}
				steps {
					url: 'https://github.com/werdervg/job1.git'
				}
		}
		stage('Push') {
				steps {
					sh 'echo 1111111Mastersss > master-file-job.txt'
				}
		}
	}
}