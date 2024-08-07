package com.friedchicken.pojo.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder
public class UserRegisterDTO implements Serializable {

    @NotBlank(message = "Email is mandatory.")
    @Email(message = "Email should be valid.")
    private String email;

    @NotBlank(message = "Password is mandatory.")
    @Size(min = 10,max = 100,message = "Password must be between 10 and 100 characters")
    private String password;
}
