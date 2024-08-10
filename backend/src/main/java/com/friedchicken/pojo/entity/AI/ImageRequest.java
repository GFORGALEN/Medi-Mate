package com.friedchicken.pojo.entity.AI;


import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ImageRequest {
    private final String model;
    private final List<Message> messages;

    public ImageRequest(String model, String prompt, String url) {
        this.model = model;
        this.messages = List.of(
                new Message("user", prompt),
                new Message("system", "Here is the image url: " + url)
        );
    }
}
