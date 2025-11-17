# Stage 1: Build the application
FROM maven:3.9.5-amazoncorretto-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Create the final image
FROM amazoncorretto:21-alpine
WORKDIR /app
COPY --from=build /app/target/laa-ccw-fees-service-0.0.1-SNAPSHOT.jar ./app.jar
RUN apk update && apk add --no-cache curl
RUN addgroup -S appgroup && adduser -u 1001 -S appuser -G appgroup
USER 1001
EXPOSE 8086
ENTRYPOINT ["java","-jar","app.jar"]
