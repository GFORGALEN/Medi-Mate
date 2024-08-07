package com.friedchicken.service.impl;

import com.friedchicken.constant.JwtClaimsConstant;
import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.AccountNotFoundException;
import com.friedchicken.exception.PasswordErrorException;
import com.friedchicken.exception.RegisterFailedException;
import com.friedchicken.mapper.UserMapper;
import com.friedchicken.pojo.dto.UserGoogleDTO;
import com.friedchicken.pojo.dto.UserInfoDTO;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.dto.UserRegisterDTO;
import com.friedchicken.pojo.entity.User;
import com.friedchicken.pojo.vo.UserLoginVO;
import com.friedchicken.properties.JwtProperties;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.BCryptUtil;
import com.friedchicken.utils.JwtUtil;
import com.friedchicken.utils.RandomStringUtil;
import com.friedchicken.utils.UniqueIdUtil;
import com.friedchicken.pojo.vo.UserInfoVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UniqueIdUtil uniqueIdUtil;
    @Autowired
    private JwtProperties jwtProperties;

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
    public UserLoginVO googleLogin(UserGoogleDTO userGoogleLoginDTO) {
        String email = userGoogleLoginDTO.getEmail();
        String googleId = userGoogleLoginDTO.getGoogleId();
        User userByEmail = userMapper.getUserByEmail(email);

        if (userByEmail == null) {
            User user = User.builder()
                    .userId(uniqueIdUtil.generateUniqueId())
                    .password(BCryptUtil.hashPassword(RandomStringUtil.generateRandomString()))
                    .build();
            BeanUtils.copyProperties(userGoogleLoginDTO,user);
            userMapper.register(user);
        } else if (!userByEmail.getGoogleId().equals(googleId)) {
            throw new PasswordErrorException(MessageConstant.PASSWORD_ERROR);
        }
        Map<String, Object> claims = new HashMap<>();
        assert userByEmail != null;
        return generateUserLoginVO(userByEmail, claims);
    }

//

    @Override
    public UserInfoVO getUser(UserInfoDTO userInfoDTO) {
        User user = userMapper.getUserByUserId(userInfoDTO.getUserId());
        return UserMapper.toVO(user);
    }

    private UserLoginVO generateUserLoginVO(User user, Map<String, Object> claims) {
        claims.put(JwtClaimsConstant.USER_ID, user.getUserId());
        claims.put(JwtClaimsConstant.USERNAME, user.getUsername());
        String token = JwtUtil.genToken(claims, jwtProperties.getUserTtl(), jwtProperties.getUserSecretKey());

        return UserLoginVO.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .token(token)
                .build();
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
