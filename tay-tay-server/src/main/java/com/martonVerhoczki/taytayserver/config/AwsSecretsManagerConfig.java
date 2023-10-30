package com.martonverhoczki.taytayserver.config;

import com.amazonaws.services.secretsmanager.AWSSecretsManager;
import com.amazonaws.services.secretsmanager.AWSSecretsManagerClientBuilder;
import com.amazonaws.services.secretsmanager.model.GetSecretValueRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class AwsSecretsManagerConfig implements CommandLineRunner {

  @Value("${spring.datasource.password}")
  private String passwordPlaceholder;

  @Override
  public void run(String... args) {
    if ("REPLACED_BY_AWS_SECRETS_MANAGER".equals(passwordPlaceholder)) {
      AWSSecretsManager client = AWSSecretsManagerClientBuilder.defaultClient();
      String secretName = "primary-db-password";

      GetSecretValueRequest request = new GetSecretValueRequest().withSecretId(secretName);
      passwordPlaceholder = client.getSecretValue(request).getSecretString();
    }
  }
}
