package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface ProductMapper {

    Page<MedicineListVO> getProducts(MedicinePageDTO medicinePageDTO);

    MedicineDetailVO getProductById(String productId);

    void updateProductById(MedicineDetailVO medicineDetailVO);

    Page<MedicineDetailVO> getDetailProducts(MedicinePageDTO medicinePageDTO);
}
