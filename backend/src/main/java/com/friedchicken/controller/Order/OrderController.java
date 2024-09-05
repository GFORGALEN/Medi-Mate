package com.friedchicken.controller.Order;

import com.friedchicken.pojo.dto.Order.OrderDTO;
import com.friedchicken.result.Result;
import com.friedchicken.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
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

@RestController
@RequestMapping("/api/order")
@Tag(name = "Order", description = "API for User to order product.")
@Slf4j
public class OrderController {
    @Autowired
    private OrderService orderService;

    @PostMapping("/orderProduct")
    @Operation(summary = "Order products.",
            description = "Order products at one pharmacy.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Buy successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = String.class)))
    })
    public Result<String> orderProduct(@RequestBody OrderDTO orderDTO) {
        log.info("Order product request{}", orderDTO);

        orderService.orderProduct(orderDTO);

        return Result.success("Order product successfully.");
    }
}
