package com.friedchicken.pojo.entity.Supplement;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SupplementInfo implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private String name;
    private String description;
    private String commonUse;
    private String sideEffects;
}
