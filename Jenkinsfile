node{
	stage ("Get Maven version") {
        	Maven_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/', returnStdout: true).trim()
	}
	stage ("Get JAVA version") {
        	JAVA_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.model.JDK/', returnStdout: true).trim()
	}
}
pipeline {
	environment {
		registry = 'registry.mydomain.com:5000'
		dockerImage = ''
		GIT_SOURCE = 'https://github.com/werdervg/start.git'
		APP_EXTPORT = '30100'
		Maven_home = '/var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation'
		MAV_VER = '$MavenVersion'
		JAVA_VER = '$JavaVersion'
		env.JAVA_HOME = '/var/jenkins_home/tools/hudson.model.JDK/$JavaVersion'
		replace_registry_path='$registry/$JOB_NAME:v$BUILD_NUMBER'
//		env.JAVA_HOME="${tool '$JavaVersion'}"
		env.PATH="${env.JAVA_HOME}/bin:${env.PATH}"
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
				sh "echo $env.JAVA_HOME"
				sh "mv Dockerfile_$JavaVersion Dockerfile"
				sh "$Maven_home/$MAV_VER/bin/mvn -Dmaven.test.failure.ignore clean package"
				sh 'cp target/*.jar app.jar'
			}
		}
	}
	stage('Building image') {
		steps{
			script {
				sh "sed -i s/#build/build/g docker-compose.yaml"
				sh "sed -i s/JOB_NAME/${JOB_NAME}/g docker-compose.yaml"
				sh "sed -i s/APP_NAME/${JOB_NAME}/g docker-compose.yaml"
				sh "sed -i s/APP_EXTPORT/${APP_EXTPORT}/g docker-compose.yaml"				
				dockerImage = docker.build registry + "/$JOB_NAME" + ":latest"
				sh "docker login https://$registry"
				sh "docker tag $registry/$JOB_NAME:latest $JOB_NAME:latest"
				sh "docker push $registry/$JOB_NAME:latest"
				sh "docker tag $registry/$JOB_NAME:latest $registry/$JOB_NAME:v$BUILD_NUMBER"
				sh "docker push $registry/$JOB_NAME:v$BUILD_NUMBER"
			}
		}
	}
	stage('Deploing image to ENV') {
		when {
			expression { params.Deploing == 'YES' }
		}
		steps {
			sh "sed -i s/build/#build/g docker-compose.yaml"
			sh "sed -i s/#image/image/g docker-compose.yaml"
			sh "docker-compose up -d"
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
