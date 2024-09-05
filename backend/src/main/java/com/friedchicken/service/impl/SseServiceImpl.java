package com.friedchicken.service.impl;

import com.friedchicken.pojo.vo.Order.OrderMessage;
import com.friedchicken.service.SseService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SseServiceImpl implements SseService {

    private final Map<String, SseEmitter> sseEmitterMap = new ConcurrentHashMap<>();

    @Override
    public SseEmitter connect(String uuid) {
        SseEmitter sseEmitter = new SseEmitter(Long.MAX_VALUE);
        try {
            sseEmitter.send(SseEmitter.event().comment("Welcome"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        sseEmitter.onCompletion(() -> {
            sseEmitterMap.remove(uuid);
        });
        sseEmitter.onTimeout(() -> {
            sseEmitterMap.remove(uuid);
        });
        sseEmitter.onError((throwable -> {
            sseEmitterMap.remove(uuid);
        }));
        sseEmitterMap.put(uuid, sseEmitter);
        return sseEmitter;
    }

    @Override
    public void sendMessage(OrderMessage orderMessage) {
        sseEmitterMap.forEach((uuid, sseEmitter) -> {
            try {
                sseEmitter.send(orderMessage, MediaType.APPLICATION_JSON);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
    }

}
