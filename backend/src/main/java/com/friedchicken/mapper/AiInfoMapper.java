package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Supplement.Supplement;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


import java.util.List;

@Mapper
public interface AiInfoMapper {

    List<Supplement> findByMultipleWords(List<String> keywords);

    List<Supplement> findProductByIds(List<Integer> productId);
}
