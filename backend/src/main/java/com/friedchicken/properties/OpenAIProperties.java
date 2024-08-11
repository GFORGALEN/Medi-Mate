package com.friedchicken.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "spring.ai.openai")
@Data
public class OpenAIProperties {
    private String apiKey;
    private String url = "https://api.openai.com";
    private String model = "gpt-4o";
    private Float temperature = 0.7F;
}
