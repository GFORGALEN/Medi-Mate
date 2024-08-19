package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.Medicine.Medicine;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


import java.util.List;

@Mapper
public interface AiInfoMapper {

    Page<MedicineListVO> findByMultipleWords(List<String> keywords);

    List<Medicine> findProductByIds(List<Integer> productId);
}
