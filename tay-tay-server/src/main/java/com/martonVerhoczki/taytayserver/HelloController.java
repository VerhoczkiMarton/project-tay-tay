package com.martonVerhoczki.taytayserver;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

  @GetMapping("/api/v1/hello")
  public String index() {
    return "Hello World!";
  }
}
