package com.friedchicken.service;

import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.entity.User;


public interface UserService {
    User login(UserLoginDTO userLoginDTO);
}
