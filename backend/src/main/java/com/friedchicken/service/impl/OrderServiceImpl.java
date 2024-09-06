package com.friedchicken.service.impl;

import com.friedchicken.mapper.OrderMapper;
import com.friedchicken.pojo.dto.Order.DetailOrderPageDTO;
import com.friedchicken.pojo.dto.Order.OrderDTO;
import com.friedchicken.pojo.dto.Order.OrderItemDTO;
import com.friedchicken.pojo.dto.Order.UpdateOrderDTO;
import com.friedchicken.pojo.entity.Order.Order;
import com.friedchicken.pojo.entity.Order.OrderItem;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;
import com.friedchicken.pojo.vo.Order.OrderMessageVO;
import com.friedchicken.service.OrderService;
import com.friedchicken.service.SseService;
import com.friedchicken.utils.UniqueIdUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private SseService sseService;
    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;
    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Override
    @Transactional
    public void orderProduct(OrderDTO orderDTO) {
        Order order = new Order();
        BeanUtils.copyProperties(orderDTO, order);
        String orderId = uniqueIdUtil.generateUniqueId();
        order.setOrderId(orderId);
        order.setStatus(0);
        orderMapper.insertOrder(order);
        for (OrderItemDTO item : orderDTO.getOrderItem()) {
            OrderItem orderItem = new OrderItem();
            BeanUtils.copyProperties(item, orderItem);
            orderItem.setOrderId(orderId);
            orderItem.setItemId(uniqueIdUtil.generateUniqueId());
            orderMapper.insertOrderItem(orderItem);
        }
        rabbitTemplate.convertAndSend("pay.topic", "pay.success", orderId);
    }

    @Override
    public void handleOrderPaymentSuccess(String orderId) {
        OrderMessageVO orderMessageVO = new OrderMessageVO();
        orderMessageVO.setOrderId(orderId);
        sseService.sendMessage(orderMessageVO);
    }

    @Override
    public List<DetailOrderVO> getOrderDetailByUserId(DetailOrderPageDTO detailOrderPageDTO) {
        return orderMapper.getOrderByUserId(detailOrderPageDTO.getUserId());
    }

    @Override
    public List<OrderItemDetailVO> getOrderItemDetailByOrderId(String orderId) {
        return orderMapper.getOrderItemDetailByOrderId(orderId);
    }

    @Override
    public List<DetailOrderVO> getOrderByPharmacyId(String pharmacyId) {
        return orderMapper.getOrderByPharmacyId(pharmacyId);
    }

    @Override
    public void updateOrderStatus(UpdateOrderDTO updateOrderDTO) {
        orderMapper.updateOrder(updateOrderDTO);
    }
}
