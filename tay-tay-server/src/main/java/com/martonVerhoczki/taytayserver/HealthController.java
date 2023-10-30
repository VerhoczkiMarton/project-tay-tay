package com.martonverhoczki.taytayserver;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

  @GetMapping("/api/v1/health")
  public String health() {
    return "OK";
  }

  @GetMapping("/api/v1/deep")
  public String deep() {
    return "OK";
  }
}
