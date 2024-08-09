package com.friedchicken.service;

import com.friedchicken.pojo.dto.User.UserGoogleDTO;
import com.friedchicken.pojo.dto.User.UserLoginDTO;
import com.friedchicken.pojo.dto.User.UserRegisterDTO;
import com.friedchicken.pojo.vo.User.UserLoginVO;


public interface UserService {
    UserLoginVO login(UserLoginDTO userLoginDTO);

    void register(UserRegisterDTO userRegisterDTO);

    UserLoginVO googleLogin(UserGoogleDTO userGoogleLoginDTO);

}
