package com.friedchicken.pojo.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class ProductPageQueryDTO implements Serializable {
    private int page;
    private int pageSize;
    private String keyword;
}
