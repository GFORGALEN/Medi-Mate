package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Supplement.SupplementDTO;
import com.friedchicken.pojo.vo.Supplement.SupplementVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface ProductMapper {

    Page<SupplementVO> getProducts(SupplementDTO supplementDTO);
}
