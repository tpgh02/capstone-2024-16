package com.dodo.exception;

import lombok.AllArgsConstructor;
import lombok.Data;
import org.springframework.http.HttpStatus;

@Data
@AllArgsConstructor
public class ErrorResult {
    private Integer code;
    private HttpStatus status;
    private String message;

    public ErrorResult(HttpStatus status, String message) {
        this.code = status.value();
        this.status = status;
        this.message = message;
    }
}
