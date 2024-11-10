package com.martonverhoczki.taytayserver.user.controller;

import com.martonverhoczki.taytayserver.user.model.User;
import com.martonverhoczki.taytayserver.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class UserController {

  UserRepository userRepository;

  @PostMapping("/api/users")
  public ResponseEntity<User> create() {
    User user = new User();
    user.setName("Teszt Elek");
    user.setEmail("mekk@mester.com");
    User savedUser = userRepository.save(user);
    return ResponseEntity.ok(savedUser);
  }

  @GetMapping("/api/users/{id}")
  public ResponseEntity<User> get(@PathVariable Long id) {
    return userRepository.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
  }
}
