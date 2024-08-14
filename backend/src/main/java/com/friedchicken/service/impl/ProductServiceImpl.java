package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Supplement.SupplementPageDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementDetailVO;
import com.friedchicken.pojo.vo.Supplement.SupplementListVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.ProductService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
@Slf4j
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public PageResult<SupplementListVO> getProductsByName(SupplementPageDTO supplementPageDTO) {

        PageHelper.startPage(supplementPageDTO.getPage(), supplementPageDTO.getPageSize());
        Page<SupplementListVO> page = productMapper.getProducts(supplementPageDTO);

        return new PageResult<>(page.getTotal(), page.getResult());
    }

    @Override
    public SupplementDetailVO getProductById(int productId) {
        return productMapper.getProductById(productId);
    }
}
