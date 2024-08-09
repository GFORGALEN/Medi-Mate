package com.friedchicken.pojo.entity.AI;


import lombok.Data;

import java.util.List;


@Data
public class ChatRequest {
    private final String model;
    private final List<Message> messages;

    public ChatRequest(String model, String prompt) {
        this.model = model;
        this.messages = List.of(new Message("user", prompt));
    }

}