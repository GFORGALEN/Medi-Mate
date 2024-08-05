package com.friedchicken.pojo.dto;

import lombok.Data;

@Data
public class UserLoginDTO {
    private String email;
    private String password;
    private String googleId;
}
