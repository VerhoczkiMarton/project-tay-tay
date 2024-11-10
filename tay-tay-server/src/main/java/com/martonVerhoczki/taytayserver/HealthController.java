package com.martonverhoczki.taytayserver;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class HealthController {

  @GetMapping("/api/v1/health")
  public String health() {
    return "Alright";
  }
}
