package com.friedchicken.pojo.entity.AI;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class OpenAIRequest {
    private String model;
    private List<Message> messages;
    private int max_tokens;
}
