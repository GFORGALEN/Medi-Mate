package com.friedchicken.controller.app.user.exception;

import com.friedchicken.exception.LoginException;

/**
 * 账号不存在异常
 */
public class AccountNotFoundException extends LoginException {

    public AccountNotFoundException() {
    }

    public AccountNotFoundException(String msg) {
        super(msg);
    }

}
