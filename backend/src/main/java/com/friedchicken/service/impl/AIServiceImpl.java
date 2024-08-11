package com.friedchicken.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.entity.AI.*;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.properties.OpenAIProperties;
import com.friedchicken.service.AIService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Mono;

import java.util.Arrays;
import java.util.List;

@Slf4j
@Service
public class AIServiceImpl implements AIService {

    @Autowired
    private OpenAIProperties openAIProperties;

    @Override
    public AItextVO handlerText(String message) {
        WebClient webClient = WebClient.builder().baseUrl(openAIProperties.getUrl()).build();
        Content textContent = new Content("text", message);
        Message userMessage = new Message("user", List.of(textContent));
        String result = webClient.post()
                .uri("/chat/completions")
                .header("Authorization", "Bearer " + openAIProperties.getApiKey())
                .header("Content-Type", "application/json")
                .bodyValue(new OpenAIRequest("gpt-4o", List.of(userMessage), 3000))
                .retrieve()
                .bodyToMono(ChatResponse.class)
                .map(response -> response.getChoices().get(0).toString())
                .onErrorResume(WebClientResponseException.class, ex -> {
                    String errorMessage = "Error: " + ex.getStatusCode() + " - " + ex.getResponseBodyAsString();
                    System.err.println(errorMessage);
                    return Mono.just(errorMessage);
                })
                .block();
        return AItextVO.builder().text(result).build();
    }

    @Override
    public AItextVO analyzeImage(AIimageDTO aiimageDTO) {
        WebClient webClient = WebClient.builder().baseUrl(openAIProperties.getUrl()).build();
        Content textContent = new Content("text", "What is in the image?");
        Content imageContent = new Content("image_url", aiimageDTO.getUrl());
        Message userMessage = new Message("user", Arrays.asList(textContent, imageContent));
        String result = webClient.post()
                .uri("/chat/completions")
                .header("Authorization", "Bearer " + openAIProperties.getApiKey())
                .header("Content-Type", "application/json")
                .bodyValue(new OpenAIRequest("gpt-4o", List.of(userMessage), 1000))
                .retrieve()
                .bodyToMono(ChatResponse.class)
                .map(response -> response.getChoices().get(0).toString())
                .onErrorResume(WebClientResponseException.class, ex -> {
                    String errorMessage = "Error: " + ex.getStatusCode() + " - " + ex.getResponseBodyAsString();
                    System.err.println(errorMessage);
                    return Mono.just(errorMessage);
                })
                .block();
        return AItextVO.builder().text(result).build();
    }
}
