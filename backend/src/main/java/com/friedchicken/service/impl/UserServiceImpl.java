package com.friedchicken.service.impl;

import com.friedchicken.constant.JwtClaimsConstant;
import com.friedchicken.constant.MessageConstant;
import com.friedchicken.controller.app.user.exception.AccountNotFoundException;
import com.friedchicken.controller.app.user.exception.PasswordErrorException;
import com.friedchicken.controller.app.user.exception.RegisterFailedException;
import com.friedchicken.mapper.UserMapper;
import com.friedchicken.pojo.dto.User.UserChangePasswordDTO;
import com.friedchicken.pojo.dto.User.UserGoogleDTO;
import com.friedchicken.pojo.dto.User.UserLoginDTO;
import com.friedchicken.pojo.dto.User.UserRegisterDTO;
import com.friedchicken.pojo.entity.User.User;
import com.friedchicken.pojo.vo.User.UserLoginVO;
import com.friedchicken.properties.JwtProperties;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.BCryptUtil;
import com.friedchicken.utils.JwtUtil;
import com.friedchicken.utils.RandomStringUtil;
import com.friedchicken.utils.UniqueIdUtil;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
@Slf4j
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;
    @Autowired
    private JwtProperties jwtProperties;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    public UserLoginVO login(UserLoginDTO userLoginDTO) {
        String email = userLoginDTO.getEmail();
        String password = userLoginDTO.getPassword();

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        if (!userByEmail.getPassword().equals(userLoginDTO.getPassword())) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }

        Map<String, Object> claims = new HashMap<>();
        return generateUserLoginVO(userByEmail, claims);
    }

    @Override
    @Transactional
    public UserLoginVO googleLogin(UserGoogleDTO userGoogleLoginDTO) {
        String email = userGoogleLoginDTO.getEmail();
        String googleId = userGoogleLoginDTO.getGoogleId();

        User userByEmail = userMapper.getUserByEmail(email);
        User user = new User();
        if (userByEmail == null) {
            user = User.builder()
                    .userId(uniqueIdUtil.generateUniqueId())
                    .password(BCryptUtil.hashPassword(RandomStringUtil.generateRandomString(16)))
                    .build();
            BeanUtils.copyProperties(userGoogleLoginDTO, user);
            userMapper.register(user);
        } else if (!userByEmail.getGoogleId().equals(googleId)) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }
        Map<String, Object> claims = new HashMap<>();
        userMapper.addUserInfo(user);
        return generateUserLoginVO(user, claims);
    }


    private UserLoginVO generateUserLoginVO(User user, Map<String, Object> claims) {
        claims.put(JwtClaimsConstant.USER_ID, user.getUserId());
        claims.put(JwtClaimsConstant.USERNAME, user.getUsername());
        String token = JwtUtil.genToken(claims, jwtProperties.getUserTtl(), jwtProperties.getUserSecretKey());
        stringRedisTemplate.opsForValue().set(token, token, 30, TimeUnit.DAYS);
        return UserLoginVO.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .userPic(user.getUserPic())
                .email(user.getEmail())
                .token(token)
                .build();
    }

    @Override
    public void register(UserRegisterDTO userRegisterDTO) {
        String email = userRegisterDTO.getEmail();

        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail != null) {
            throw new RegisterFailedException(MessageConstant.ACCOUNT_ALREADY_EXIST);
        } else {
            User user = new User();
            BeanUtils.copyProperties(userRegisterDTO, user);
            user.setUserId(uniqueIdUtil.generateUniqueId());
            user.setUsername(RandomStringUtil.generateRandomString(6));
            userMapper.register(user);
        }
    }

    @Override
    public void updatePassword(UserChangePasswordDTO userChangePasswordDTO) {
        String email = userChangePasswordDTO.getEmail();
        User userByEmail = userMapper.getUserByEmail(email);
        if (userByEmail == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }
        if (!userByEmail.getPassword().equals(userChangePasswordDTO.getOldPassword())) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }
        userByEmail.setPassword(userChangePasswordDTO.getNewPassword());
        userMapper.update(userByEmail);

    }
}
