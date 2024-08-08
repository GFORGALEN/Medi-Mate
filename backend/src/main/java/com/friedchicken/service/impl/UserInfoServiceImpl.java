package com.friedchicken.service.impl;

import com.friedchicken.mapper.UserInfoMapper;
import com.friedchicken.pojo.dto.UserInfoDTO;
import com.friedchicken.pojo.vo.UserInfoVO;
import com.friedchicken.service.UserInfoService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserInfoServiceImpl implements UserInfoService {

    private static final Logger log = LoggerFactory.getLogger(UserInfoServiceImpl.class);
    @Autowired
    UserInfoMapper userInfoMapper;

    @Override
    public UserInfoVO getUserInfo(UserInfoDTO userInfoDTO) {
        UserInfoVO userByUserId = userInfoMapper.getUserByUserId(userInfoDTO.getUserId());
        log.info("here:{}", userByUserId);
        return userByUserId;
    }

}
