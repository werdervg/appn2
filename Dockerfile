FROM java:8
WORKDIR /
ADD *.jar app.jar
EXPOSE 8080
CMD java - jar app.jar
