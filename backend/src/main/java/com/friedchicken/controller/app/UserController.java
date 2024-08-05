package com.friedchicken.controller.app;

import com.friedchicken.constant.JwtClaimsConstant;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.entity.User;
import com.friedchicken.pojo.vo.UserLoginVO;
import com.friedchicken.properties.JwtProperties;
import com.friedchicken.result.Result;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
@Tag(name = "JWT Controller", description = "API for JWT operations")
@Slf4j
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private JwtProperties jwtProperties;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    @Operation(summary = "User Login", description = "Generates a JWT for user login")
    public Result<UserLoginVO> login(@RequestBody UserLoginDTO userLoginDTO){
        log.info("A user want to login in:{}",userLoginDTO.toString());

        User user = userService.login(userLoginDTO);

        Map<String,Object> claims=new HashMap<>();

        claims.put(JwtClaimsConstant.USER_ID,user.getUserId());
        String token= jwtUtil.generateUserToken(user.getUsername(),claims);

        UserLoginVO userLoginVO = UserLoginVO.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .token(token)
                .build();
        return Result.success(userLoginVO);
    }
}
