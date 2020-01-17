node {
	def mvnHome
	stage('Preparation') {
		git 'https://github.com/werdervg/start.git'
		mvnHome = tool 'maven 3.6.3'
	}
	stage('Build') {
		withEnv(["MVN_HOME=$mvnHome"]) {
			if (isUnix()) {
				sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
		} else {
			bat(/"%MVN_HOME%\bin\mvn" -Dmaven.test.failure.ignore clean package/)
		}
		sh 'cp target/*.jar app.jar'
	}
}
	stage('Build Docker Image') {
			echo "Initializing workflow"
			sh 'docker-compose --project-name $JOB_NAME build  && echo "Build Finished" || exit 1'
			sh 'docker login https://registry.mydomain.com:5000'
			sh 'docker tag "$JOB_NAME"_app:latest registry.mydomain.com:5000/"$JOB_NAME"_app:v$BUILD_NUMBER'
			sh 'docker push registry.mydomain.com:5000/"$JOB_NAME"_app:v$BUILD_NUMBER'
	}
}
