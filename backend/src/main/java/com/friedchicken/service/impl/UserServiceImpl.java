package com.friedchicken.service.impl;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.AccountNotFoundException;
import com.friedchicken.exception.PasswordErrorException;
import com.friedchicken.mapper.UserMapper;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.entity.User;
import com.friedchicken.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    public User login(UserLoginDTO userLoginDTO) {
        String email = userLoginDTO.getEmail();
        String password = userLoginDTO.getPassword();

        if (email == null || password == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }

        User userByEmail = userMapper.getUserByEmail(email);
        if (!userByEmail.getPassword().equals(userLoginDTO.getPassword())) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }

        return userByEmail;
    }
}
