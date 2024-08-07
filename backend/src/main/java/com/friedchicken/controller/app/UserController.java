package com.friedchicken.controller.app;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.AccountNotFoundException;
import com.friedchicken.pojo.dto.UserGoogleDTO;
import com.friedchicken.pojo.dto.UserLoginDTO;
import com.friedchicken.pojo.dto.UserRegisterDTO;
import com.friedchicken.pojo.vo.UserLoginVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.UserService;
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


@RestController
@RequestMapping("/api/user")
@Tag(name = "User", description = "API for User corresponding operations")
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

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

        String email = userLoginDTO.getEmail();
        String password = userLoginDTO.getPassword();

        if (email == null || password == null) {
            throw new AccountNotFoundException(MessageConstant.ACCOUNT_NOT_FOUND);
        }

        UserLoginVO userLoginVO = userService.login(userLoginDTO);

        return Result.success(userLoginVO);
    }

    @PostMapping("/google-login")
    @Operation(summary = "Google Register",
            description = "If the user want to use Google to login, it will use this API.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Google successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserGoogleDTO.class)))
    })
    public Result<UserLoginVO> googleLogin(
            @Parameter(description = "Google information", required = true)
            @RequestBody UserGoogleDTO userGoogleLoginDTO
    ) {
        log.info("A user want to use Google to login:{}", userGoogleLoginDTO);

        String email = userGoogleLoginDTO.getEmail();
        String googleId = userGoogleLoginDTO.getGoogleId();

        if(email == null || googleId == null) {
            throw new AccountNotFoundException(MessageConstant.WRONG_INPUT);
        }
        UserLoginVO userLoginVO = userService.googleLogin(userGoogleLoginDTO);
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
