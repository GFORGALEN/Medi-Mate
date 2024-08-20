package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.User.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Select("select * from user where email = #{email}")
    User getUserByEmail(String email);

    void register(User user);

    void update(User user);

    void addUserInfo(User user);

}
