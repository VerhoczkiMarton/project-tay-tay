FROM amazoncorretto:21-alpine AS base

WORKDIR /usr/src/app

COPY build.gradle.kts settings.gradle.kts gradlew ./
COPY gradle/ ./gradle/

RUN ./gradlew dependencies --no-daemon

FROM base AS development

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=development

COPY ./src/main ./src/main

CMD ["./gradlew", "bootRun", "--no-daemon"]

FROM base AS build

COPY ./src/main ./src/main

RUN ./gradlew assemble --no-daemon

FROM amazoncorretto:21 AS production

WORKDIR /usr/src/app

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=production

COPY --from=build /usr/src/app/build/libs/*.jar ./application.jar

ENTRYPOINT ["java", "-jar", "application.jar"]
