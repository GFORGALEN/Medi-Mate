package com.friedchicken.controller.app;

import com.friedchicken.pojo.dto.AI.AItextDTO;
import com.friedchicken.pojo.vo.AI.AItextVO;
import com.friedchicken.result.Result;
import com.friedchicken.service.AIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    @ApiResponse(value = {@ApiResponse(responseCode = "200", description = "Handle successfully.",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AItextVO.class)))})
    public Result<AItextVO> sendMessage(
            @Parameter(description = "User send message.", required = true)
            @RequestBody AItextDTO aitextDTO
    ) {
        log.info("User want to use AI model to send message.");

        AItextVO aitextVO = aiService.handlerText(aitextDTO.getMessage());

        return Result.success(aitextVO);
    }
}
