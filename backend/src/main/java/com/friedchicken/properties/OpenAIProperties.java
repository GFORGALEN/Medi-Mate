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
    private String model = "gpt-4o-2024-08-06";
    private Float temperature = 0.7F;
    private String jsonSchema = """
            {
                "type": "object",
                "properties": {
                    "name": {"type": "string","description": "The name of the product"},
                    "description": { "type": "string","description": "The general description of the product" },
                    "commonUse": { "type": "string", "description": "The common use of the product" },
                    "sideEffects": { "type": "string", "description": "The side effect of the product" }
                },
                "required": ["name", "description", "commonUse", "sideEffects"],
                "additionalProperties": false
            }
            """;
}
