package com.friedchicken.service.impl;

import com.friedchicken.mapper.ProductMapper;
import com.friedchicken.pojo.dto.Medicine.MedicineModifyDTO;
import com.friedchicken.pojo.dto.Medicine.MedicinePageDTO;
import com.friedchicken.pojo.vo.Medicine.MedicineDetailVO;
import com.friedchicken.pojo.vo.Medicine.MedicineListVO;
import com.friedchicken.result.PageResult;
import com.friedchicken.service.ProductService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Slf4j
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;
    @Autowired
    private AiServiceImpl aiServiceImpl;

    @Override
    public PageResult<MedicineListVO> getProductsByName(MedicinePageDTO medicinePageDTO) {

        PageHelper.startPage(medicinePageDTO.getPage(), medicinePageDTO.getPageSize());
        Page<MedicineListVO> page = productMapper.getProducts(medicinePageDTO);

        return new PageResult<>(page.getTotal(), page.getResult());
    }

    @Override
    @Transactional
    public MedicineDetailVO getProductById(String productId) {
        MedicineDetailVO productById = productMapper.getProductById(productId);
        if (productById.getSummary() == null) {
            String text = aiServiceImpl.handlerText("You are a professional pharmacist, give me a brief summary."
                    + productById.toString()).getText();
            productById.setSummary(text);
            productMapper.updateProductById(productById);
        }
        return productById;
    }

    @Override
    public PageResult<MedicineDetailVO> getDetailProductsByName(MedicinePageDTO medicinePageDTO) {
        PageHelper.startPage(medicinePageDTO.getPage(), medicinePageDTO.getPageSize());
        Page<MedicineDetailVO> page = productMapper.getDetailProducts(medicinePageDTO);

        return new PageResult<>(page.getTotal(), page.getResult());
    }

    @Override
    public void updateProductInformation(MedicineModifyDTO medicineModifyDTO) {
        MedicineDetailVO medicineDetailVO = new MedicineDetailVO();
        BeanUtils.copyProperties(medicineModifyDTO, medicineDetailVO);
        productMapper.updateProductById(medicineDetailVO);
    }
}
