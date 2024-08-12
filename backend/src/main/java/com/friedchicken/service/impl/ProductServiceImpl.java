package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Product.ProductDTO;
import com.friedchicken.pojo.vo.Product.ProductVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public PageResult<ProductVO> getProducts(ProductDTO productDTO) {
        int offset = productDTO.getPage() * productDTO.getSize();
        List<ProductVO> products = productMapper.getProducts(offset, productDTO.getSize(), productDTO.getProductName(), productDTO.getProductId(), productDTO.getManufacture());
        long total = products.size();
        return new PageResult<>(total, products);
    }
}
