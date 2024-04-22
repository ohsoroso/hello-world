# Start with a base image containing Java runtime
FROM openjdk:21

# Set the working directory in the container
WORKDIR /app

# Copy the jar file from your target directory to the working directory
COPY target/helloWorld-1.0-SNAPSHOT.jar /app/app.jar

# Make port 8081 available to the world outside this container
EXPOSE 8081

# Execute the application
ENTRYPOINT ["java", "-jar", "app.jar"]
