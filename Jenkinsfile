def code

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
			stage('Load') {
				steps {
					code = load 'example.groovy'
				}	
			}
			stage('Execute') {
				steps {
					code.example1()
				}
			}
		}
	}