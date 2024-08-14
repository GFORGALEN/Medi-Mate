package com.friedchicken.pojo.vo.Supplement;

import lombok.Builder;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
public class SupplementListVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String productId;
    private String productName;
    private String productPrice;
    private String imageSrc;
}