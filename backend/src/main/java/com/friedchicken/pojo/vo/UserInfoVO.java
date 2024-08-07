package com.friedchicken.pojo.vo;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserInfoVO implements Serializable {
    private int  userId;
    private int  birthDay;
    private double userWeight;
    private double userHeight;
}
//VO 用于后端向前端传输数据