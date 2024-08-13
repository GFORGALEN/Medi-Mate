package com.friedchicken.pojo.dto.Supplement;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class SupplementDTO implements Serializable {
    private int page = 1;         // 页码
    private int pageSize = 10;         // 每页大小
    private String productName;  // 商品名称（可选）
    private String manufacture;  // 生产厂家（可选）
}
