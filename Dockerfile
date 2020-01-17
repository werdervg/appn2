FROM java:8
WORKDIR /
COPY target/simple-maven-project-with-tests-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD java - jar app.jar
