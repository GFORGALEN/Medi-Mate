package com.friedchicken.controller.app;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.ImageFailedUploadException;
import com.friedchicken.pojo.dto.AI.AItextDTO;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.AIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/message")
@Tag(name = "Message", description = "API for User to send message.")
@Slf4j
public class AIController {

    @Autowired
    private AIService aiService;

    @PostMapping("/text")
    @Operation(summary = "User send message to connect AI model.",
            description = "If the user want to search information from model,it will return a message from model.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Login successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = AItextVO.class)))
    })
    public Result<AItextVO> sendMessage(
            @Parameter(description = "User send message.", required = true)
            @RequestBody AItextDTO aitextDTO
    ) {
        log.info("User want to use AI model to send message.{}", aitextDTO.toString());

        AItextVO aitextVO = aiService.handlerText(aitextDTO.getMessage());

        return Result.success(aitextVO);
    }

    @PostMapping("/image")
    @Operation(summary = "User send image to connect AI model.",
            description = "If the user want to search image from model,it will return a message from model.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Login successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = AItextVO.class)))
    })
    public Result<AItextVO> sendImage(
            @Parameter(description = "User send image.", required = true)
            @RequestBody MultipartFile file
    ) {
        log.info("User want to use AI model to send image.");

        AItextVO aitextVO;
        try {
            byte[] imageBytes = file.getBytes();
            aitextVO = aiService.analyzeImage(imageBytes);
        } catch (IOException e) {
            throw new ImageFailedUploadException(MessageConstant.FILE_UPLOAD_ERROR);
        }
        return Result.success(aitextVO);
    }
}
