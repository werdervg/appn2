node{
	stage ("Get Maven version") {
        	Maven_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/', returnStdout: true).trim()
	}
	stage ("Get JAVA version") {
        	JAVA_Version = sh (script: 'ls /var/jenkins_home/tools/Java/', returnStdout: true).trim()
	}
}
pipeline {
	environment {
		ExternalPort = "8090"
		InternalPort = "8080"
		registry = 'registry.mydomain.com:5000'
		dockerImage = ''
		GIT_SOURCE = 'https://github.com/werdervg/start.git'
		Maven_home = '/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation'
		MAV_VER = '$MavenVersion'
		JAVA_VER = '$JavaVersion'
//		JAVA_HOME = '/var/jenkins_home/tools/Java/$JavaVersion'
	}
agent any
	parameters {
		choice(name: 'MavenVersion', choices: "${Maven_Version}", description: 'On this step you need select Maven Version')
		choice(name: 'JavaVersion', choices: "${JAVA_Version}", description: 'On this step you need select JAVA Version')
		choice(name: 'Deploing', choices: "NO\nYES", description: 'Option for allow/decline deploy to ENV')
	}
stages {
	stage('Build With maven') {
		steps {
			script {
//				sh "echo $JAVA_HOME"
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

        stage('Deploy docker image to ENV') {
		when {
			expression { params.Deploing == 'YES' }
		}
		steps('Prepering docker-teplate file') {
			sh """sed -i 's/app_name/$JOB_NAME/g' docker-teplate.yaml"""
			sh """sed -i 's/image_location/$registry\/$JOB_NAME:v$BUILD_NUMBER/g' docker-teplate.yaml"""
			sh """sed -i 's/ExternalPort/$ExternalPort/g' docker-teplate.yaml"""
			sh """sed -i 's/InternalPort/$InternalPort/g' docker-teplate.yaml"""

		}
		steps {
			sh "docker-compose -f docker-teplate.yaml up -d || exit 1"
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
