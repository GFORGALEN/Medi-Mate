package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Supplement.Supplement;
import com.friedchicken.pojo.vo.Supplement.SupplementListVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


import java.util.List;

@Mapper
public interface AiInfoMapper {

    Page<SupplementListVO> findByMultipleWords(List<String> keywords);

    List<Supplement> findProductByIds(List<Integer> productId);
}
