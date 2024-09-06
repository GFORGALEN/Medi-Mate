package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Order.Order;
import com.friedchicken.pojo.entity.Order.OrderItem;
import com.friedchicken.pojo.vo.Order.DetailOrderVO;
import com.friedchicken.pojo.vo.Order.OrderItemDetailVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderMapper {

    void insertOrderItem(OrderItem orderItem);

    void insertOrder(Order order);

    Order getOrderByOrderId(String orderId);

    List<DetailOrderVO> getOrderByUserId(String userId);

    List<OrderItemDetailVO> getOrderItemDetailByOrderId(String orderId);
}
