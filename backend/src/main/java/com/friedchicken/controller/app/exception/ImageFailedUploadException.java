package com.friedchicken.controller.app.exception;

import com.friedchicken.exception.BaseException;

public class ImageFailedUploadException extends BaseException {
    public ImageFailedUploadException() {
    }

    public ImageFailedUploadException(String msg) {
        super(msg);
    }
}
