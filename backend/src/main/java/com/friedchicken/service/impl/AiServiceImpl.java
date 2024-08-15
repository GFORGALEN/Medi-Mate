package com.friedchicken.service.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.friedchicken.mapper.AiInfoMapper;
import com.friedchicken.pojo.dto.AI.AIimageDTO;
import com.friedchicken.pojo.entity.Supplement.Supplement;
import com.friedchicken.pojo.entity.Supplement.SupplementInfo;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.properties.OpenAIProperties;
import com.friedchicken.service.AiService;
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

import java.util.Arrays;
import java.util.List;

@Slf4j
@Service
public class AiServiceImpl implements AiService {

    @Autowired
    private OpenAIProperties openAIProperties;

    @Autowired
    private AiInfoMapper aiInfoMapper;

    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public AItextVO handlerText(String message) {
        UserMessage userMessage = new UserMessage(message);

        ChatResponse chatResponse = getAiClass(userMessage);
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();

        return AItextVO.builder()
                .text(requestContent)
                .build();
    }

    @Override
    public AItextVO analyzeImageUrl(AIimageDTO aiimageDTO) {
        UserMessage userMessage = new UserMessage("Tell my the text on this picture.", List.of(new Media(MimeTypeUtils.IMAGE_JPEG, aiimageDTO.getUrl())));

        ChatResponse chatResponse = getAiClass(userMessage);
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();

        return AItextVO.builder()
                .text(requestContent)
                .build();
    }

    @Override
    public AItextVO analyzeImage(byte[] imageData) {
        Resource imageResource = new ByteArrayResource(imageData);

        UserMessage userMessage = new UserMessage("Tell me the text on this picture. Please be more specific and comprehensive."
                , List.of(new Media(MimeTypeUtils.IMAGE_PNG, imageResource)));

        ChatResponse chatResponse = getAiClass(userMessage);
        String requestContent = chatResponse.getResults().get(0).getOutput().getContent();

        SupplementInfo supplementInfo;
        try {
            supplementInfo = objectMapper.readValue(requestContent, SupplementInfo.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        String name = supplementInfo.getName();
        List<String> keywords = Arrays.asList(name.split("\\s+"));
        List<Supplement> supplement = aiInfoMapper.findByMultipleWords(keywords);

        return AItextVO.builder()
                .text(requestContent)
                .build();
    }

    private ChatResponse getAiClass(UserMessage userMessage) {
        OpenAiApi openAiApi = new OpenAiApi(openAIProperties.getApiKey());
        OpenAiChatOptions openAiChatOptions = OpenAiChatOptions.builder()
                .withModel(openAIProperties.getModel())
                .withTemperature(openAIProperties.getTemperature())
                .withMaxTokens(1000)
                .withResponseFormat(new OpenAiApi.ChatCompletionRequest.ResponseFormat(
                        OpenAiApi.ChatCompletionRequest.ResponseFormat.Type.JSON_SCHEMA, openAIProperties.getJsonSchema()))
                .build();
        OpenAiChatModel openAiChatModel = new OpenAiChatModel(openAiApi, openAiChatOptions);

        return openAiChatModel.call(new Prompt(userMessage));
    }
}
