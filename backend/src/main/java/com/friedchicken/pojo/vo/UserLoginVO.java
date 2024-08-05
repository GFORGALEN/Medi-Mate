package com.friedchicken.pojo.vo;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserLoginVO implements Serializable {
    private Long userId;
    private String username;
    private String email;
    private String token;
}
