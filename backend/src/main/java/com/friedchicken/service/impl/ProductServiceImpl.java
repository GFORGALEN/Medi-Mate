package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Supplement.SupplementDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementVO;
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
    public PageResult<SupplementVO> getProductsByName(SupplementDTO supplementDTO) {

        PageHelper.startPage(supplementDTO.getPage(), supplementDTO.getPageSize());
        Page<SupplementVO> page = productMapper.getProducts(supplementDTO);

        log.info("page:{}", page);
        return new PageResult<>(page.getTotal(), page.getResult());
    }
}
