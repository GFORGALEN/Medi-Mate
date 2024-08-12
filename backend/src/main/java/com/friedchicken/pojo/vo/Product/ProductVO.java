package com.friedchicken.pojo.vo.Product;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class ProductVO implements Serializable {
    private String productId;
    private String productName;
    private String productPrice;
    private String manufacture;
    private String imageSrc;
}
