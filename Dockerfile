# Stage 1: Build the application
# ========================
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the Spring Boot application (skip tests for faster build)
RUN mvn clean package

# ========================
# Stage 2: Run the application
# ========================
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=builder /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Start the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]