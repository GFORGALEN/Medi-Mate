package com.friedchicken.pojo.vo.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderMessage implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String orderId;
}
