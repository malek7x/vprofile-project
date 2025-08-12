# # Stage 1: Build the application
# FROM maven:3.9.6-eclipse-temurin-21 AS builder
# WORKDIR /app

# # Copy pom.xml and source code
# COPY pom.xml .
# COPY src ./src

# # Build the Spring Boot application (skip tests for faster build)
# RUN mvn clean package

# # Stage 2: Run the application
# # ========================
# FROM eclipse-temurin:21-jdk
# WORKDIR /app
# EXPOSE 8080
# COPY --from=builder /app/target/*.war vprofile.war
# ENTRYPOINT ["java", "-jar", "vprofile.war"]
FROM maven:3.9.9-eclipse-temurin-21-jammy AS BUILD_IMAGE
RUN git clone https://github.com/hkhcoder/vprofile-project.git
RUN cd vprofile-project && git checkout docker && mvn install

FROM tomcat:10-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]


