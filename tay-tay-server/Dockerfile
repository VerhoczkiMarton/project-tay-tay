FROM amazoncorretto:21-alpine AS development

WORKDIR /usr/src/app

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=development

FROM amazoncorretto:21 AS build

ARG DATABASE_URL
ARG POSTGRES_PASSWORD

WORKDIR /usr/src/app

COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle/ ./gradle/

RUN ./gradlew dependencies

COPY ./src/main ./src/main

RUN ./gradlew assemble

FROM amazoncorretto:21 AS production

ARG DATABASE_URL
ARG POSTGRES_PASSWORD

WORKDIR /usr/src/app

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=production

COPY --from=build /usr/src/app/build/libs/*.jar ./application.jar

ENTRYPOINT ["java", "-jar", "application.jar"]
