package com.friedchicken.controller.product;

import com.friedchicken.pojo.dto.Supplement.SupplementDTO;
import com.friedchicken.pojo.dto.Supplement.SupplementPageDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementDetailVO;
import com.friedchicken.pojo.vo.Supplement.SupplementListVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.result.Result;
import com.friedchicken.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@Tag(name = "Product", description = "API for User to get products.")
@Slf4j
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    @Operation(summary = "Get Products list",
            description = "Retrieve a list of products with pagination and optional filtering by name, ID, or manufacture.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Products retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PageResult.class)))
    })
    public Result<PageResult<SupplementListVO>> getProducts(SupplementPageDTO supplementPageDTO) {

        log.info("User want to retrieve products by product name:{}", supplementPageDTO.getProductName());

        PageResult<SupplementListVO> pageResult=productService.getProductsByName(supplementPageDTO);

        return Result.success(pageResult);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get Detail Products",
            description = "Retrieve a specific product.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Product retrieved successfully.",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = SupplementDetailVO.class)))
    })
    public Result<SupplementDetailVO> getProduct(@PathVariable("id") int productId) {
        log.info("User want to retrieve the specific product by product id:{}", productId);

        SupplementDetailVO supplementDetailVO = productService.getProductById(productId);

        return Result.success(supplementDetailVO);
    }
}
