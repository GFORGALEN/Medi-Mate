package com.friedchicken.listener;

import com.friedchicken.service.OrderService;
import com.friedchicken.service.SseService;
import com.rabbitmq.client.Channel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Slf4j
public class OrderStatusListener {
    @Autowired
    private OrderService orderService;  // 确保你有适当的方法来处理支付成功
    @Autowired
    private SseService sseService;

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pay.queue", durable = "true"),
            exchange = @Exchange(name = "pay.topic", type = ExchangeTypes.TOPIC),
            key = "pay.success"
    ))
    public void listenOrderPay(String orderId, Channel channel, @Header(AmqpHeaders.DELIVERY_TAG) long tag) throws IOException {
        if (!sseService.hasActiveConnections()) {
            // 没有活跃的连接，拒绝消息并重新排队
            channel.basicReject(tag, true);
        } else {
            orderService.handleOrderPaymentSuccess(orderId);
            log.info("Payment success for order: {}", orderId);
            channel.basicAck(tag, false);
        }
    }
}
