package com.friedchicken.controller.app.AI.exception;

import com.friedchicken.exception.BaseException;

public class ImageFailedUploadException extends BaseException {
    public ImageFailedUploadException() {
    }

    public ImageFailedUploadException(String msg) {
        super(msg);
    }
}
