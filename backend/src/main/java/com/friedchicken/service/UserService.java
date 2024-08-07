package com.friedchicken.service;

import com.friedchicken.pojo.dto.UserGoogleDTO;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.dto.UserRegisterDTO;
import com.friedchicken.pojo.vo.UserLoginVO;


public interface UserService {
    UserLoginVO login(UserLoginDTO userLoginDTO);

    void register(UserRegisterDTO userRegisterDTO);

    UserLoginVO googleLogin(UserGoogleDTO userGoogleLoginDTO);

}
