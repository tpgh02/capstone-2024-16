package com.dodo.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class ApiExceptionAdvice {

    @ExceptionHandler(NotFoundException.class)
    public ErrorResult notFoundHandler(NotFoundException e) {
        e.printStackTrace();
        return new ErrorResult(HttpStatus.NOT_FOUND, e.getMessage());
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ErrorResult unAuthorizedHandler(UnauthorizedException e) {
        e.printStackTrace();
        return new ErrorResult(HttpStatus.UNAUTHORIZED, e.getMessage());
    }

    @ExceptionHandler(RuntimeException.class)
    public ErrorResult DefaultHandler(RuntimeException e) {
        e.printStackTrace();
        return new ErrorResult(HttpStatus.INTERNAL_SERVER_ERROR, e.getMessage());
    }

}
