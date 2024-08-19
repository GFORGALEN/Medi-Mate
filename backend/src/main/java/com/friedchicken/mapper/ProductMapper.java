package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Supplement.SupplementDTO;
import com.friedchicken.pojo.dto.Supplement.SupplementPageDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementDetailVO;
import com.friedchicken.pojo.vo.Supplement.SupplementListVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface ProductMapper {

    Page<SupplementListVO> getProducts(SupplementPageDTO supplementPageDTO);

    SupplementDetailVO getProductById(String productId);

    void updateProductById(SupplementDetailVO supplementDetailVO);

    Page<SupplementDetailVO> getDetailProducts(SupplementPageDTO supplementPageDTO);
}
