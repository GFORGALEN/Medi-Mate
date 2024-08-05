package com.friedchicken.pojo.dto;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserLoginDTO implements Serializable {
    private String email;
    private String password;
}
