package com.friedchicken.handler;

import com.friedchicken.controller.app.AI.exception.ImageFailedUploadException;
import com.friedchicken.controller.app.user.exception.LoginFailedException;
import com.friedchicken.exception.BaseException;
import com.friedchicken.exception.LoginException;
import com.friedchicken.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Result<?>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((org.springframework.validation.FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return new ResponseEntity<>(Result.error(errors.toString()), HttpStatus.BAD_REQUEST);
    }

//    @ExceptionHandler(Exception.class)
//    public ResponseEntity<Result<?>> handleGlobalException(Exception ex) {
//        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
//    }

    @ExceptionHandler(LoginException.class)
    public ResponseEntity<Result<?>> handleSpecificException(LoginException ex) {
        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(ImageFailedUploadException.class)
    public ResponseEntity<Result<?>> handleSpecificException(ImageFailedUploadException ex) {
        return new ResponseEntity<>(Result.error(ex.getMessage()), HttpStatus.BAD_REQUEST);
    }
}
