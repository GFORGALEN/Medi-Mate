package com.friedchicken.pojo.dto.User;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserInfoDTO implements Serializable {
    private String userId;
}
//DTO用于前端向后端传输数据