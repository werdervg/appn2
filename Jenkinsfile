node{
	stage ("Get tools version") {
		Maven_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/', returnStdout: true).trim()
		JAVA_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.model.JDK/', returnStdout: true).trim()
	}
	stage ("Get JAVA version") {
		JAVA_Version = sh (script: 'ls /var/jenkins_home/tools/hudson.model.JDK/', returnStdout: true).trim()
	}
}
pipeline {
agent any
	parameters {
		choice(name: 'MavenVersion', choices: "${Maven_Version}", description: 'On this step you need select Maven Version')
		choice(name: 'JavaVersion', choices: "${JAVA_Version}", description: 'On this step you need select JAVA Version')
		choice(name: 'Deploing', choices: "NO\nYES", description: 'Option for allow/decline deploy to ENV')
	}
	environment {
		registry = 'registry.mydomain.com:5000'
		dockerImage = ''
		GIT_SOURCE = 'https://github.com/werdervg/start.git'
		APP_EXTPORT = '30100'
		replace_registry_path='$registry/$JOB_NAME:v$BUILD_NUMBER'
		Maven_OPTS = '-Dmaven.test.failure.ignore'
	}
	tools {
		maven "${params.MavenVersion}"
		jdk "${params.JavaVersion}"
	}
stages {
	stage('Build With maven') {
		steps {
			script {
				sh "mv Dockerfile_$JavaVersion Dockerfile"
				sh "mvn $Maven_OPTS clean package"
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
				sh "sed -i s/REGISTRY_NAME/${registry}/g docker-compose.yaml"
				dockerImage = docker.build registry + "/$JOB_NAME" + ":v$BUILD_NUMBER"
				sh "docker login https://$registry"
				sh "docker push $registry/$JOB_NAME:v$BUILD_NUMBER"
				sh "docker tag $registry/$JOB_NAME:v$BUILD_NUMBER $registry/$JOB_NAME:latest"
				sh "docker push $registry/$JOB_NAME:latest"
			}
		}
	}
	stage('Deploing image to ENV') {
		when {
			expression { params.Deploing == 'YES' }
		}
		steps {
			step {
				sh "sed -i s/build/#build/g docker-compose.yaml"
				sh "sed -i s/#image/image/g docker-compose.yaml"
			}	sh "docker-compose up -d"
			step {
				script {
					def remote = [:]
					remote.name = 'CINODE1'
					remote.host = 'cinode1.domain.com'
					remote.user = 'user'
					remote.password = 'password'
					remote.allowAnyHosts = true
					sshPut remote: remote, from: 'docker-compose.yaml', into: '.', override: true
					sshCommand remote: remote, command: 'docker-compose up --build -d'
				}
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
