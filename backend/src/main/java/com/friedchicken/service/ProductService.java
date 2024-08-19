package com.friedchicken.service;

import com.friedchicken.pojo.dto.Supplement.SupplementPageDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementDetailVO;
import com.friedchicken.pojo.vo.Supplement.SupplementListVO;
import com.friedchicken.result.PageResult;

public interface ProductService {

    PageResult<SupplementListVO> getProductsByName(SupplementPageDTO supplementPageDTO);

    SupplementDetailVO getProductById(String productId);

    PageResult<SupplementDetailVO> getDetailProductsByName(SupplementPageDTO supplementPageDTO);
}
