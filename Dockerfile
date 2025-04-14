FROM maven:3.8.6-eclipse-temurin-17 AS lint-test

WORKDIR /app

COPY . .

RUN mvn pmd:pmd

RUN mvn test


FROM maven:3.8.6-eclipse-temurin-17 AS build

WORKDIR /app

COPY --from=lint-test /app /app

COPY --from=lint-test /root/.m2 /root/.m2

RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"] 