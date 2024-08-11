package com.friedchicken.pojo.entity.AI;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ContentDeserializer extends JsonDeserializer<List<Content>> {

    @Override
    public List<Content> deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonNode node = p.getCodec().readTree(p);
        List<Content> contents = new ArrayList<>();

        if (node.isArray()) {
            for (JsonNode item : node) {
                if (item.isTextual()) {
                    contents.add(new Content("text", item.asText()));
                } else if (item.has("url")) {
                    contents.add(new Content("image_url", item.asText()));
                }
            }
        } else if (node.isTextual()) {
            contents.add(new Content("text", node.asText()));
        }

        return contents;
    }
}
