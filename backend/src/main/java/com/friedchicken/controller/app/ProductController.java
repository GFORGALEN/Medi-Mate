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
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@Slf4j
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
    public Result<PageResult<ProductVO>> getProducts(ProductDTO productDTO) {

        log.info("User want to retrieve products by product name:{}", productDTO.getProductName());

        PageResult<ProductVO> pageResult=productService.getProductsByName(productDTO);

        return Result.success();
    }
}
