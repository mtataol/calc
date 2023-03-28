#FROM frolvlad/alpine-java
FROM xiehaijun/jdk11
COPY build/libs/calculator-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
