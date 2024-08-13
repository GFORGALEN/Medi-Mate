package com.friedchicken.service;

import com.friedchicken.pojo.dto.Product.ProductDTO;
import com.friedchicken.pojo.vo.Product.ProductVO;
import com.friedchicken.result.PageResult;

public interface ProductService {

    PageResult<ProductVO> getProductsByName(ProductDTO productDTO);
}
