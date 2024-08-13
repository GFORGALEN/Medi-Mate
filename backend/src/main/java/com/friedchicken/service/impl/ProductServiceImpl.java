package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Product.ProductDTO;
import com.friedchicken.pojo.vo.Product.ProductVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.ProductService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public PageResult<ProductVO> getProductsByName(ProductDTO productDTO) {
        PageHelper.startPage(productDTO.getPage(), productDTO.getSize());
        Page<ProductVO> page = productMapper.getProducts(productDTO);
        return new PageResult<ProductVO>(page.getTotal(), page.getResult());
    }
}
