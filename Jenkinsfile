node {
	def mvnHome
	def REGISTRY_URL
	def GIT_SOURCE
	stage('Preparation') {
		REGISTRY_URL = "registry.mydomain.com:5000"
		GIT_SOURCE = "https:github.com/werdervg/start.git"
		sh 'rm -rf ./*'
		git url: GIT_SOURCE
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
			sh 'docker login https://$REGISTRY_URL'
			sh 'docker tag "$JOB_NAME"_app:latest "$REGISTRY_URL"/"$JOB_NAME"_app:latest'
			sh 'docker push "$REGISTRY_URL"/"$JOB_NAME"_app:latest'
			sh 'docker tag "$JOB_NAME"_app:latest "$REGISTRY_URL"/"$JOB_NAME"_app:v$BUILD_NUMBER'
			sh 'docker push "$REGISTRY_URL"/"$JOB_NAME"_app:v$BUILD_NUMBER'
	}
	stage('Clean Docker Image') {
			sh 'docker rmi -f "$JOB_NAME"_app:latest'
			sh 'docker rmi -f "$REGISTRY_URL"/"$JOB_NAME"_app:v$BUILD_NUMBER'
			sh 'docker rmi -f "$REGISTRY_URL"/"$JOB_NAME"_app:latest'
	}
}
