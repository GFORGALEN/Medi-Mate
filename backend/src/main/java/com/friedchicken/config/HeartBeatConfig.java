package com.friedchicken.config;


import com.friedchicken.pojo.vo.Order.OrderMessage;
import com.friedchicken.service.SseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Configuration
public class HeartBeatConfig {
    @Autowired
    private SseService sseService;

    @Scheduled(fixedRate = 20000)
    public void sendMessageTask() {
        OrderMessage orderMessage = new OrderMessage();
        orderMessage.setOrderId("ping");
        sseService.sendMessage(orderMessage);
    }
}
