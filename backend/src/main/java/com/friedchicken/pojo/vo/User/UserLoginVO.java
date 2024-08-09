package com.friedchicken.pojo.vo.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserLoginVO implements Serializable {
    private String userId;
    private String username;
    private String email;
    private String userPic;
    private String token;
}
