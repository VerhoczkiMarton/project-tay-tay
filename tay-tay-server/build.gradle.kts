plugins {
	java
	checkstyle
	id("org.springframework.boot") version "3.1.4"
	id("io.spring.dependency-management") version "1.1.3"
}

group = "com.martonverhoczki"
version = "0.0.1-SNAPSHOT"

java {
	sourceCompatibility = JavaVersion.VERSION_21
}

configurations {
	compileOnly {
		extendsFrom(configurations.annotationProcessor.get())
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	compileOnly("org.projectlombok:lombok")
	developmentOnly("org.springframework.boot:spring-boot-devtools")
	annotationProcessor("org.projectlombok:lombok")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	implementation("org.postgresql:postgresql:42.2.27")
	implementation("com.amazonaws:aws-java-sdk-secretsmanager:1.12.576")
	implementation("org.springframework.boot:spring-boot-starter-data-jpa:3.1.5")
	implementation("org.hibernate.orm:hibernate-core:6.3.1.Final")
	implementation("org.flywaydb:flyway-core:9.22.3")
	testImplementation("io.zonky.test:embedded-database-spring-test:2.3.0")
}

checkstyle {
	toolVersion = "10.12.4"
	configFile = rootProject.file("config/checkstyle/checkstyle.xml")
}

tasks.withType<Test> {
	useJUnitPlatform()
}

tasks.named<Jar>("jar") {
	enabled = false
}
