# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the Spring Boot application (skip tests for faster build)
RUN mvn clean package

# Stage 2: Run the application
# ========================
FROM eclipse-temurin:21-jdk
WORKDIR /app
EXPOSE 8080
COPY --from=builder /app/target/*.war vprofile.war
ENTRYPOINT ["java", "-jar", "vprofile.war"]



