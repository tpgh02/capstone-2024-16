package com.dodo.chat.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MessageDTO {
    private Long userId;
    private String message;
    private LocalDateTime time;

    public MessageDTO(Message message) {
        this.userId = message.getUserId();
        this.message = message.getMessage();
        this.time = message.getTime();
    }
}
