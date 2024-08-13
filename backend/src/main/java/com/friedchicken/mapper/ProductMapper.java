package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Product.ProductDTO;
import com.friedchicken.pojo.vo.Product.ProductVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface ProductMapper {

    Page<ProductVO> getProducts(ProductDTO productDTO);
}
