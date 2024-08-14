package com.friedchicken.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

@Configuration
public class DataSourceConfig {

    @Value("${spring.datasource.url}")
    private String datasourceUrl;

    @Value("${spring.datasource.username}")
    private String datasourceUsername;

    @Value("${spring.datasource.password}")
    private String datasourcePassword;

    @PostConstruct
    public void logDatabaseConnectionInfo() {
        System.out.println("Database Connection Information:");
        System.out.println("URL: " + datasourceUrl);
        System.out.println("Username: " + datasourceUsername);
        System.out.println("Password: " + datasourcePassword);
    }
}