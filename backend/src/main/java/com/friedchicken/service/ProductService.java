package com.friedchicken.service;

import com.friedchicken.pojo.dto.Supplement.SupplementDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementVO;
import com.friedchicken.result.PageResult;

public interface ProductService {

    PageResult<SupplementVO> getProductsByName(SupplementDTO supplementDTO);
}
