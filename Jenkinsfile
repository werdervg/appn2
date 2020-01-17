GIT_SOURCE = "https://github.com/werdervg/start.git"
node {
	def mvnHome
	def REGISTRY_URL
	docker.withRegistry('https://registry.mydomain.com:5000') 
	stage('Preparation') {
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
		def testImage = docker.build("test-image", "./Dockerfile") 
		customImage.push()
		customImage.push('latest')
	}
}
