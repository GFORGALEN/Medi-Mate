package com.friedchicken.controller.app.exception;

import com.friedchicken.exception.BaseException;

/**
 * 账号不存在异常
 */
public class AccountNotFoundException extends BaseException {

    public AccountNotFoundException() {
    }

    public AccountNotFoundException(String msg) {
        super(msg);
    }

}
