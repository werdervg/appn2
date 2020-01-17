node {
   def mvnHome
   stage('Preparation') {
      git 'https://github.com/jglick/simple-maven-project-with-tests.git'
      mvnHome = tool 'maven 3.6.3'
   }
   stage('Build Source') {
      withEnv(["MVN_HOME=$mvnHome"]) {
            sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
         }
      }
   stage('Build Docker Image') {
      git https://github.com/werdervg/prod.git
      sh 'cp target/*.jar prod/'
      def customImage = docker.build("my-image:${env.BUILD_ID}")
   }
   }
