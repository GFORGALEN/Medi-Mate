package com.friedchicken.controller.app.exception;

import com.friedchicken.exception.BaseException;

public class RegisterFailedException extends BaseException {
    public RegisterFailedException(String msg) {
        super(msg);
    }
}
