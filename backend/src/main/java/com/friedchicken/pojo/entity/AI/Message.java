package com.friedchicken.pojo.entity.AI;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class Message {
    private String role;

    @JsonDeserialize(using = ContentDeserializer.class)
    private List<Content> content;

}