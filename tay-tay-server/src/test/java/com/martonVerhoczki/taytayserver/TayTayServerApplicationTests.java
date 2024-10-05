package com.martonverhoczki.taytayserver;

import io.zonky.test.db.AutoConfigureEmbeddedDatabase;
import javax.sql.DataSource;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@AutoConfigureEmbeddedDatabase
@ActiveProfiles("test")
class TayTayServerApplicationTests {

  @Autowired
  private DataSource dataSource;

  @Test
  void contextLoads() {
  }
}
