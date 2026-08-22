# specifies base image we want to extend from --> works on arm mac, linux etc.
FROM eclipse-temurin:17-jdk

#ENV spring.datasource.url

# compiled springboot file
ARG JAR_FILE=target/gutapp-0.0.1-SNAPSHOT.jar
#copy target file to new file called docker-gutapp...
COPY ${JAR_FILE} docker-gutapp-0.0.1-SNAPSHOT.jar

# Specify default commands. --> default command is to run the jar file.
CMD ["java", "-jar","docker-gutapp-0.0.1-SNAPSHOT.jar"]


