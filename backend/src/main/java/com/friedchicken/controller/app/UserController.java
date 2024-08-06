package com.friedchicken.controller.app;

import com.friedchicken.constant.JwtClaimsConstant;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.dto.UserRegisterDTO;
import com.friedchicken.pojo.entity.User;
import com.friedchicken.pojo.vo.UserLoginVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.UserService;
import com.friedchicken.utils.JwtUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
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
@Tag(name = "User", description = "API for User corresponding operations")
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    @Operation(summary = "User Login",
            description = "If the user has been registered, it will return a token to the user.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Login successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserLoginVO.class)))
    })
    public Result<UserLoginVO> login(
            @Parameter(description = "User login credentials", required = true)
            @RequestBody UserLoginDTO userLoginDTO) {
        log.info("A user want to login in:{}", userLoginDTO.toString());

        User user = userService.login(userLoginDTO);

        Map<String, Object> claims = new HashMap<>();
        claims.put(JwtClaimsConstant.USER_ID, user.getUserId());
        String token = jwtUtil.generateUserToken(user.getUsername(), claims);

        UserLoginVO userLoginVO = UserLoginVO.builder()
                .userId(user.getUserId())
                .username(user.getUsername())
                .email(user.getEmail())
                .token(token)
                .build();
        return Result.success(userLoginVO);
    }

    @PostMapping("/register")
    @Operation(summary = "User Register",
            description = "If the user has not been registered, it will use this API to create a new user.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Register successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserLoginVO.class)))
    })
    public Result<UserLoginVO> register(
            @Parameter(description = "User register information", required = true)
            @Valid @RequestBody UserRegisterDTO userRegisterDTO
    ) {
        log.info("A new user want to create:{}", userRegisterDTO.toString());
        userService.register(userRegisterDTO);
        return Result.success();
    }
}
