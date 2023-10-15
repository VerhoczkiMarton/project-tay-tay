FROM amazoncorretto:21 AS build

WORKDIR /usr/src/app

COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle/ ./gradle/

RUN ./gradlew dependencies

COPY ./src/main ./src/main

RUN ./gradlew assemble

FROM amazoncorretto:21 AS production

WORKDIR /usr/src/app

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=production

COPY --from=build /usr/src/app/build/libs/*.jar ./application.jar

FROM amazoncorretto:21-alpine AS development

WORKDIR /usr/src/app

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=development