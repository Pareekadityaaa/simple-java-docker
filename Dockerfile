# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

COPY src/Main.java .

RUN javac Main.java


# Runtime stage
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /app/Main.class .

CMD ["java", "Main"]
