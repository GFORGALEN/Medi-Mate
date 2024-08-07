package com.friedchicken.service;

import com.friedchicken.pojo.dto.UserInfoDTO;
import com.friedchicken.pojo.vo.UserInfoVO;

public interface UserInfoService {

    UserInfoVO getUserInfo(UserInfoDTO userInfoDTO);
}
