package com.martonverhoczki.taytayserver.user.controller;

import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "api/v1", produces = MediaType.APPLICATION_JSON_VALUE)
@CrossOrigin(origins = "*")
public class UserController {

  @GetMapping(value = "/public_users")
  public String publicEndpoint() {
    return "PUBLIC USERS ACCESSED";
  }

  @PostMapping(value = "/private_users")
  public String privateEndpoint(@AuthenticationPrincipal Jwt principal, @RequestBody Map<String, Object> requestBody) {
    System.out.println("principal: " + principal);
    System.out.println("data: " + requestBody);
    return "PRIVATE USERS ACCESSED";
  }

  @GetMapping(value = "/private-scoped_users")
  public String privateScopedEndpoint() {
    return "PRIVATE SCOPED USERS ACCESSED";
  }
}
