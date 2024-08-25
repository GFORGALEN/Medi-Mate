package com.friedchicken.mapper;

import com.friedchicken.pojo.dto.Medicine.MedicineLocationDTO;
import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.pojo.vo.Medicine.MedicineLocationVO;
import com.github.pagehelper.Page;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface ProductMapper {

    Page<MedicineListVO> getProducts(MedicinePageDTO medicinePageDTO);

    MedicineDetailVO getProductById(String productId);

    void updateProductById(MedicineDetailVO medicineDetailVO);

    Page<MedicineDetailVO> getDetailProducts(MedicinePageDTO medicinePageDTO);

    List<String> getAllManufactureName();

    MedicineLocationVO getProductLocation(MedicineLocationDTO medicineLocationDTO);
}
