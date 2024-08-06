package com.friedchicken.handler;

import com.friedchicken.constant.MessageConstant;
import com.friedchicken.exception.BaseException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.friedchicken.result.Result;

import java.sql.SQLIntegrityConstraintViolationException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler
    public Result exceptionHandler(BaseException ex) {
        log.error("异常信息：{}", ex.getMessage());
        return Result.error(ex.getMessage());
    }

    /**
     * @author TZzzQAQ
     * @date 2024/8/6
     **/
    @ExceptionHandler
    public Result exceptionHandler(SQLIntegrityConstraintViolationException exception) {
        log.error("出现数据库重复输入异常");
        //使用contains函数对于是否存在冗余输入的问题
        if (exception.getMessage().contains("Duplicate entry")) {
            //使用split分割以空格为分割的字符串数组
            String[] s = exception.getMessage().split(" ");
            return Result.error(s[2] + MessageConstant.ACCOUNT_ALREADY_EXIST);
        }
        return Result.error(MessageConstant.UNKNOWN_ERROR);
    }
}
