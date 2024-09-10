package com.friedchicken.listener;

import com.friedchicken.listener.Exception.NoStaffException;
import com.friedchicken.pojo.entity.Order.OrderEmail;
import com.friedchicken.service.OrderService;
import com.friedchicken.service.SseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.ExchangeTypes;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;


@Component
@Slf4j
public class OrderStatusListener {
    @Autowired
    private OrderService orderService;
    @Autowired
    private SseService sseService;
    @Autowired
    private JavaMailSender mailSender;

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pay.queue", durable = "true"),
            exchange = @Exchange(name = "pay.topic", type = ExchangeTypes.TOPIC),
            key = "pay.success"
    ))
    public void listenOrderPay(String orderId) {
        if (!sseService.hasActiveConnections()) {
            throw new NoStaffException("NO STAFF CONNECTIONS");
        } else {
            orderService.handleOrderPaymentSuccess(orderId);
            log.info("Payment success for order: {}", orderId);
        }
    }

    @RabbitListener(bindings = @QueueBinding(
            value = @Queue(name = "mark.order.pick.queue",durable = "true"),
            exchange = @Exchange(name = "pick.topic",type = ExchangeTypes.TOPIC),
            key = "pick.success"
    ))
    public void listenOrderPick(OrderEmail orderEmail) {
        SimpleMailMessage message = new SimpleMailMessage();
        log.info("Order picked: {}", orderEmail);
        message.setTo(orderEmail.getEmail());
        message.setSubject("Order Completion Notification");
        message.setText("Dear " + orderEmail.getNickname() + ",\n\n" +
                "Your order with ID " + orderEmail.getOrderId() + " has been completed successfully.\n" +
                "Thank you for shopping with us!\n\n" +
                "Best regards,\n" +
                "Your Company Name");
        mailSender.send(message);
    }
}
