package com.martonverhoczki.taytayserver.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DatabaseConfiguration {

  @Value("${spring.datasource.password}")
  private String databasePassword;

  @Bean
  public void logDatabasePassword() {
    System.out.println("VERHODEBUG: Resolved Database Password: " + databasePassword);
  }
}
