package com.martonverhoczki.taytayserver.user.controller;

import com.martonverhoczki.taytayserver.user.model.User;
import com.martonverhoczki.taytayserver.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class UserController {

  UserRepository userRepository;

  @GetMapping("/api/v1/create")
  public String create() {
    User user = new User();
    user.setName("Teszt Elek");
    user.setEmail("mekk@mester.com");
    User savedUser = userRepository.save(user);
    return savedUser.toString();
  }

  @GetMapping("/api/v1/get/{id}")
  public String get(@PathVariable Long id) {
    return userRepository.findById(id).toString();
  }
}
