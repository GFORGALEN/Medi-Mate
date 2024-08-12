package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.AI.Supplement;
import com.friedchicken.pojo.entity.AI.SupplementInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AiInfoMapper {

    @Select("SELECT * FROM supplement WHERE product_name LIKE CONCAT('%', #{name}, '%')")
    Supplement getProductByName(SupplementInfo supplementInfo);
}
