package com.friedchicken.service;

import com.friedchicken.pojo.dto.User.UserInfoDTO;
import com.friedchicken.pojo.vo.User.UserInfoVO;

public interface UserInfoService {

    UserInfoVO getUserInfo(UserInfoDTO userInfoDTO);
}
