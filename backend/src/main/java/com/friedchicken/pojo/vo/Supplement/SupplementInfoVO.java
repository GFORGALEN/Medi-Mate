package com.friedchicken.pojo.vo.Supplement;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class SupplementInfoVO implements Serializable {
    private String productId;
    private String productName;
    private String productPrice;
    private String manufactureName;
    private String imageSrc;
}
