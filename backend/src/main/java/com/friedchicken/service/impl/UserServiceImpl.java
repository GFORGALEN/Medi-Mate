package com.friedchicken.service.impl;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.AccountNotFoundException;
import com.friedchicken.exception.PasswordErrorException;
import com.friedchicken.exception.RegisterFailedException;
import com.friedchicken.mapper.UserMapper;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.dto.UserRegisterDTO;
import com.friedchicken.pojo.entity.User;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.UniqueIdUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;

    public User login(UserLoginDTO userLoginDTO) {
        String email = userLoginDTO.getEmail();
        String password = userLoginDTO.getPassword();

        if (email == null || password == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        if (!userByEmail.getPassword().equals(userLoginDTO.getPassword())) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }

        return userByEmail;
    }

    @Override
    public void register(UserRegisterDTO userRegisterDTO) {
        String email = userRegisterDTO.getEmail();
        String password = userRegisterDTO.getPassword();

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail != null) {
            throw new RegisterFailedException(MessageConstant.ACCOUNT_ALREADY_EXIST);
        } else {
            User user = new User();
            BeanUtils.copyProperties(userRegisterDTO, user);
            user.setUserId(uniqueIdUtil.generateUniqueId());
            userMapper.register(user);
        }
    }
}
