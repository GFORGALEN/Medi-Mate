package com.friedchicken.pojo.dto.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserChangePasswordDTO implements Serializable {
    private String email;
    private String oldPassword;
    private String newPassword;
}
