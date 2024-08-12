package com.friedchicken.service.impl;

import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.properties.OpenAIProperties;
import com.friedchicken.service.AIService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.model.Media;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.MimeTypeUtils;
import reactor.core.publisher.Flux;

import java.util.Base64;
import java.util.List;

@Slf4j
@Service
public class AIServiceImpl implements AIService {

    @Autowired
    private OpenAIProperties openAIProperties;

    @Override
    public AItextVO handlerText(String message) {
        OpenAiApi openAiApi = new OpenAiApi(openAIProperties.getApiKey());
        OpenAiChatOptions openAiChatOptions = OpenAiChatOptions.builder()
                .withModel(openAIProperties.getModel())
                .withTemperature(openAIProperties.getTemperature())
                .withMaxTokens(1000)
                .build();
        OpenAiChatModel openAiChatModel = new OpenAiChatModel(openAiApi, openAiChatOptions);

        ChatResponse chatResponse = openAiChatModel.call(new Prompt(message));

        return AItextVO.builder()
                .text(chatResponse.getResults().get(0).getOutput().getContent())
                .build();
    }

    @Override
    public AItextVO analyzeImageUrl(AIimageDTO aiimageDTO) {
        UserMessage userMessage = new UserMessage("Tell my the text on this picture.", List.of(new Media(MimeTypeUtils.IMAGE_JPEG, aiimageDTO.getUrl())));

        OpenAiApi openAiApi = new OpenAiApi(openAIProperties.getApiKey());
        OpenAiChatOptions openAiChatOptions = OpenAiChatOptions.builder()
                .withModel(openAIProperties.getModel())
                .withTemperature(openAIProperties.getTemperature())
                .withMaxTokens(1000)
                .build();

        OpenAiChatModel openAiChatModel = new OpenAiChatModel(openAiApi, openAiChatOptions);

        ChatResponse chatResponse = openAiChatModel.call(new Prompt(userMessage));

        return AItextVO.builder()
                .text(chatResponse.getResults().get(0).getOutput().getContent())
                .build();
    }

    @Override
    public AItextVO analyzeImage(byte[] imageData) {
        Resource imageResource = new ByteArrayResource(imageData);
        UserMessage userMessage = new UserMessage("Tell my the text on this picture."
                , List.of(new Media(MimeTypeUtils.IMAGE_PNG, imageResource)));

        OpenAiApi openAiApi = new OpenAiApi(openAIProperties.getApiKey());
        OpenAiChatOptions openAiChatOptions = OpenAiChatOptions.builder()
                .withModel(openAIProperties.getModel())
                .withTemperature(openAIProperties.getTemperature())
                .withMaxTokens(1000)
                .build();

        OpenAiChatModel openAiChatModel = new OpenAiChatModel(openAiApi, openAiChatOptions);

        ChatResponse chatResponse = openAiChatModel.call(new Prompt(userMessage));

        return AItextVO.builder()
                .text(chatResponse.getResults().get(0).getOutput().getContent())
                .build();
    }
}
