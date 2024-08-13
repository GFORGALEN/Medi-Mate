package com.friedchicken.controller.app.exception;

import com.friedchicken.exception.BaseException;

/**
 * 登录失败
 */
public class LoginFailedException extends BaseException {
    public LoginFailedException(String msg) {
        super(msg);
    }
}
