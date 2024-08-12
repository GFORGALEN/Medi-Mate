package com.friedchicken.controller.app;

import com.friedchicken.pojo.dto.Product.ProductDTO;
import com.friedchicken.pojo.vo.Product.ProductVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.result.Result;
import com.friedchicken.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    @Operation(summary = "Get Products",
            description = "Retrieve a list of products with pagination and optional filtering by name, ID, or manufacture.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Products retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PageResult.class)))
    })
    public Result<PageResult<ProductVO>> getProducts(
            @RequestParam int page,
            @RequestParam int size,
            @RequestParam(required = false) String productName,
            @RequestParam(required = false) String productId,
            @RequestParam(required = false) String manufacture) {

        ProductDTO productDTO = ProductDTO.builder()
                .page(page)
                .size(size)
                .productName(productName)
                .productId(productId)
                .manufacture(manufacture)
                .build();

        return Result.success(productService.getProducts(productDTO));
    }
}
