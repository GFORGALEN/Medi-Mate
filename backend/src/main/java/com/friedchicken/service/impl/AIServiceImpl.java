package com.friedchicken.service.impl;

import com.friedchicken.pojo.entity.AI.ChatRequest;
import com.friedchicken.pojo.entity.AI.ChatResponse;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.properties.OpenAIProperties;
import com.friedchicken.service.AIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;

@Service
public class AIServiceImpl implements AIService {

    @Autowired
    private OpenAIProperties openAIProperties;

    @Override
    public AItextVO handlerText(String message) {
        WebClient webClient = WebClient.builder().baseUrl(openAIProperties.getUrl()).build();
        String result = webClient.post()
                .uri("/chat/completions")
                .header("Authorization", "Bearer " + openAIProperties.getApiKey())
                .header("Content-Type", "application/json")
                .bodyValue(new ChatRequest("gpt-4o-mini", message))
                .retrieve()
                .bodyToMono(ChatResponse.class)
                .map(response -> response.getChoices().get(0).getMessage().getContent())
                .onErrorResume(WebClientResponseException.class, ex -> {
                    return Mono.just("Error: " + ex.getMessage());
                })
                .block();
        return AItextVO.builder().text(result).build();
    }

    public Mono<String> generateChatCompletion(String prompt) {
        WebClient webClient = WebClient.builder().baseUrl(openAIProperties.getUrl()).build();
        return webClient.post()
                .uri("/chat/completions")
                .header("Authorization", "Bearer " + openAIProperties.getApiKey())
                .header("Content-Type", "application/json")
                .bodyValue(new ChatRequest("gpt-4o", prompt))
                .retrieve()
                .bodyToMono(ChatResponse.class)
                .map(response -> response.getChoices().get(0).getMessage().getContent())
                .onErrorResume(WebClientResponseException.class, ex -> {
                    return Mono.just("Error: " + ex.getMessage());
                });
    }
}
