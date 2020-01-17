node {
   def mvnHome
   stage('Preparation') {
      git 'https://github.com/werdervg/start.git'
      mvnHome = tool 'maven 3.6.3'
   }
   stage('Build') {
      // Run the maven build
      withEnv(["MVN_HOME=$mvnHome"]) {
         if (isUnix()) {
            sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
         } else {
            bat(/"%MVN_HOME%\bin\mvn" -Dmaven.test.failure.ignore clean package/)
         }
      }
   }
}
pipeline {
agent none
	stages {
		stage('Build Docker Image') {
			steps {
				echo "Initializing workflow"
			        sh 'cp target/*.jar prod/'
				sh 'docker-compose --project-name $JOB_NAME $environment build  && echo "Build Finished" || exit 1'
				sh 'docker login https://registry.mydomain.com:5000'
			}
		}
	}
}
