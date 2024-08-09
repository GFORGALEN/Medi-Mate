package com.friedchicken.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "fc.openai")
@Data
public class OpenAIProperties {
    private String apiKey;
    private String url;
}
