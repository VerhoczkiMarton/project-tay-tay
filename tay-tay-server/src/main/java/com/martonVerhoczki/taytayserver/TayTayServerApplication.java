package com.martonverhoczki.taytayserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
public class TayTayServerApplication {

  public static void main(String[] args) {
    SpringApplication.run(TayTayServerApplication.class, args);
  }
}
