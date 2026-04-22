FROM eclipse-temurin:17-jdk

ARG JAR_FILE=target/gutapp-0.0.1-SNAPSHOT.jar

COPY ${JAR_FILE} docker-gutapp-0.0.1-SNAPSHOT.jar

CMD ["java", "-jar", "docker-gutapp-0.0.1-SNAPSHOT.jar"]
