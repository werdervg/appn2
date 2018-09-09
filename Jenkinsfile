pipeline {
agent any
		stages {
			stage('Clone job 1') {
			    agent {
					label 'master'
				}
				steps {
					git url: 'https://github.com/werdervg/job1.git'
				}
			}
		}
}