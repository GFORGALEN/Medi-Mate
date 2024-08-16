package com.friedchicken.pojo.vo.Supplement;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class SupplementComparisonVO implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String productId;
    private String productName;
    private String generalInformation;
    private String warnings;
    private String commonUse;
    private String ingredients;
    private String directions;
    private String imageSrc;
}
