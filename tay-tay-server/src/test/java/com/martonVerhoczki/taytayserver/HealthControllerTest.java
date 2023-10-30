package com.martonverhoczki.taytayserver;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class HealthControllerTest {
  @Test
  void health() {
    HealthController healthController = new HealthController();
    assertEquals("OK", healthController.health());
  }

  @Test
  void failing() {
    HealthController healthController = new HealthController();
    assertEquals("NOT-OK", healthController.health());
  }
}