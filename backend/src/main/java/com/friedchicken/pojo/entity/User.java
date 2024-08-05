package com.friedchicken.pojo.entity;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class User implements Serializable {
    private Long userId;
    private String username;
    private String email;
    private String password;
    private String googleId;
    private String createdAt;
    private String updatedAt;
}
