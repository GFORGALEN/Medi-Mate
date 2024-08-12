package com.friedchicken.mapper;

import com.friedchicken.pojo.vo.Product.ProductVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ProductMapper {

    @Select("<script>" +
            "SELECT product_id AS productId, product_nam AS productName, product_pri AS productPrice, manufacture, image_src AS imageSrc " +
            "FROM supplement " +
            "WHERE 1=1 " +
            "<if test='productId != null and !productId.isEmpty()'>" +
            "AND product_id = #{productId} " +
            "</if>" +
            "<if test='productName != null and !productName.isEmpty()'>" +
            "AND product_nam LIKE CONCAT('%', #{productName}, '%') " +
            "</if>" +
            "<if test='manufacture != null and !manufacture.isEmpty()'>" +
            "AND manufacture LIKE CONCAT('%', #{manufacture}, '%') " +
            "</if>" +
            "<if test='productId == null or productId.isEmpty()'>" +
            "ORDER BY product_id " +
            "LIMIT #{size} OFFSET #{offset} " +
            "</if>" +
            "</script>")
    List<ProductVO> getProducts(@Param("offset") int offset, @Param("size") int size,
                                @Param("productName") String productName,
                                @Param("productId") String productId,
                                @Param("manufacture") String manufacture);
}
