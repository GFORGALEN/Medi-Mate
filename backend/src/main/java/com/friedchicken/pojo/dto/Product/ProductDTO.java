package com.friedchicken.pojo.dto.Product;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class ProductDTO implements Serializable {
    private int page;         // 页码
    private int size;         // 每页大小
    private String productName;  // 商品名称（可选）
    private String manufacture;  // 生产厂家（可选）
}
