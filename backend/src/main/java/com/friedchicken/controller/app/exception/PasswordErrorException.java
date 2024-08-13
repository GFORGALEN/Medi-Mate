package com.friedchicken.controller.app.exception;

import com.friedchicken.exception.BaseException;

/**
 * 密码错误异常
 */
public class PasswordErrorException extends BaseException {

    public PasswordErrorException() {
    }

    public PasswordErrorException(String msg) {
        super(msg);
    }

}
