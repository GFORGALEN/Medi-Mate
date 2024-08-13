package com.friedchicken.pojo.vo.Supplement;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class SupplementVO implements Serializable {
    private String productId;
    private String productName;
    private String productPrice;
    private String manufacturerName;
    private String generalInformation;
    private String warnings;
    private String commonUse;
    private String ingredients;
    private String directions;
    private String imageSrc;
}