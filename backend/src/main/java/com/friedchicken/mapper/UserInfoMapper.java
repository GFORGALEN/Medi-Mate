package com.friedchicken.mapper;

import com.friedchicken.pojo.vo.UserInfoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserInfoMapper {

    @Select("select * from user_info where user_id = #{userId}")
    UserInfoVO getUserByUserId(String userId);
}
