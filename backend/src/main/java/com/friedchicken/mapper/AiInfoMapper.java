package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Supplement.Supplement;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


import java.util.List;

@Mapper
public interface AiInfoMapper {

    List<Supplement> findByMultipleWords(@Param("keywords") List<String> keywords);

}
