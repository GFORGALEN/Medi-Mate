package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Order.Order;
import com.friedchicken.pojo.entity.Order.OrderItem;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {

    void insertOrderItem(OrderItem orderItem);

    void insertOrder(Order order);

    Order getOrderByOrderId(String orderId);
}
