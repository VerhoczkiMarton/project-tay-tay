package com.martonverhoczki.taytayserver.config;

import static org.springframework.security.config.Customizer.withDefaults;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    return http
            .authorizeHttpRequests((authorize) -> authorize
                    .requestMatchers("/api/v1/public_users").permitAll()
                    .requestMatchers("/api/v1/private_users").authenticated()
                    .requestMatchers("/api/v1/private-scoped_users").hasAuthority("SCOPE_read:users")
            )
            .cors(withDefaults())
            .oauth2ResourceServer(oauth2 -> oauth2
                    .jwt(withDefaults())
            )
            .build();
  }
}