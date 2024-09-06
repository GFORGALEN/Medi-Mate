package com.friedchicken.pojo.vo.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DetailOrderVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String orderId;
    private double amount;
    private String userId;
    private int pharmacyId;
    private int status;
}
