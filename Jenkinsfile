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
		stage('Clone job 2') {
				steps {
					git url: 'https://github.com/werdervg/job2.git'
				}
		}
//		stage('Push') {
//				steps {
//					
//					sh 'echo 1111111Mastersss > master-file-job.txt'
//				}
//		}
	}
}