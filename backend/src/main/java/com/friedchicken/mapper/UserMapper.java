package com.friedchicken.mapper;

import com.friedchicken.pojo.entity.User.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Select("select * from users where email = #{email}")
    User getUserByEmail(String email);

    @Insert("insert into users (user_id, username, email, password, google_id, created_at, updated_at) " +
            "VALUES (#{userId},#{username},#{email},#{password},#{googleId},#{createdAt},#{updatedAt})")
    void register(User build);

}
