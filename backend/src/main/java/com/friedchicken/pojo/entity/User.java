package com.friedchicken.pojo.entity;

import lombok.Data;

@Data
public class User {
    private Long userId;
    private String username;
    private String email;
    private String password;
    private String googleId;
    private String createdAt;
    private String updatedAt;
}
