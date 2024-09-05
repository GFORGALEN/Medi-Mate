package com.friedchicken.listener;

import com.friedchicken.service.OrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class OrderStatusListener {
    @Autowired
    private OrderService orderService;  // 确保你有适当的方法来处理支付成功

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pay.queue",durable = "true"),
            exchange = @Exchange(name="pay.topic",type = ExchangeTypes.TOPIC),
            key = "pay.success"
    ))
    public void listenOrderPay(String orderId){
        orderService.handleOrderPaymentSuccess(orderId);
        log.info("Payment success for order: {}", orderId);
    }
}
