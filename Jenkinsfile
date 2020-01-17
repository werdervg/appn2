node{
	stage ("Get Maven version") {
		sh 'ls /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/ > maven.txt'
		sh 'cat maven.txt'
		Maven_Version = readFile 'maven.txt'		
	}
}
pipeline {
	environment {
		registry = 'registry.mydomain.com:5000'
		dockerImage = ''
		Maven_home = '/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation'
		GIT_SOURCE = 'https://github.com/werdervg/start.git'
		MAV_VER = '$MavenVersion'
	}
agent any
	parameters {
		choice(name: 'MavenVersion', choices: "${Maven_Version}", description: 'On this step you need select Maven Version')
		choice(name: 'Deploing', choices: "YES\NO", description: 'Option for allow/decline deploy to ENV')
	}
stages {
	stage('Build With maven') {
		steps {
			script {
				sh "$Maven_home/$MAV_VER/bin/mvn -Dmaven.test.failure.ignore clean package"
				sh 'cp target/*.jar app.jar'
			}
		}
	}
	stage('Building image') {
		steps{
			script {
				dockerImage = docker.build registry + "/$JOB_NAME" + ":latest"
				sh "docker login https://$registry"
				sh "docker push $registry/$JOB_NAME:latest"
				sh "docker tag $registry/$JOB_NAME:latest $registry/$JOB_NAME:v$BUILD_NUMBER"
				sh "docker push $registry/$JOB_NAME:v$BUILD_NUMBER"
			}
		}
	}
	stage('Remove Unused docker image') {
		steps{
			sh "docker rmi -f $registry/$JOB_NAME:latest"
			sh "docker rmi -f $registry/$JOB_NAME:v$BUILD_NUMBER"
			sh "rm -rf ./*"
		}
	}
}
}
