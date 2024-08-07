package com.friedchicken.controller.app;

import com.friedchicken.pojo.vo.UserInfoVO;
import com.friedchicken.service.UserService;
import com.friedchicken.result.Result;
import com.friedchicken.pojo.dto.UserInfoDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/userinfo")
@Tag(name = "User Info", description = "API for User information operations")
@Slf4j
public class UserInfoController {

    @Autowired
    private UserService userService;

    @PostMapping("/getUserInfo")
    @Operation(summary = "Get User Info by User ID",
            description = "Retrieve user information by user ID.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User information retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = UserInfoVO.class)))
    })
    public Result<UserInfoVO> getUserInfo(
            @Parameter(description = "User ID", required = true)
            @RequestBody UserInfoDTO userInfoDTO) {
        log.info("Getting user information for userId: {}", userInfoDTO.getUserId());

        UserInfoVO userInfoVO = userService.getUser(userInfoDTO);

        return Result.success(userInfoVO);
    }
}
