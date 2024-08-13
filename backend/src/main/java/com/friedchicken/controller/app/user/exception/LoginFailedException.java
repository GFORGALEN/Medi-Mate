package com.friedchicken.controller.app.user.exception;

import com.friedchicken.exception.LoginException;

/**
 * 登录失败
 */
public class LoginFailedException extends LoginException {
    public LoginFailedException(String msg) {
        super(msg);
    }
}
