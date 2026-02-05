
# Build 
FROM maven:3-openjdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
#this was old RUN mvn clean compile assembly:single -f /home/app/pom.xml crashed changed to new one below
RUN mvn clean package -DskipTests -f /home/app/pom.xml

# Package
# change from old depracted openjdk to new one avalibale on docker hub
FROM eclipse-temurin:11-jre-jammy 
RUN apt update && apt install -y libfreetype-dev && rm -rf /var/lib/apt/lists/*
COPY --from=build /home/app/target/server.jar /usr/local/lib/server.jar
COPY config /config
COPY resources /resources

# Mounts
VOLUME /cache
VOLUME /config

# Ports
EXPOSE 8080

# Command
CMD [ "java", "-jar", "/usr/local/lib/server.jar", "--language", "en_US", "--port", "8080" ]
