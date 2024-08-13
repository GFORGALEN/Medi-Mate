package com.friedchicken.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Supplement implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private String productName;
    private double productPrice;
    private String manufacturerName;
    private String productId;
    private String generalInformation;
    private String warnings;
    private String commonUse;
    private String ingredients;
    private String directions;
    private String imageSrc;
}
