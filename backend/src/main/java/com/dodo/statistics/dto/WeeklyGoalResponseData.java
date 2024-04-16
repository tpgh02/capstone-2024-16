package com.dodo.statistics.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class WeeklyGoalResponseData {
    String date;
    Boolean flag;

    public WeeklyGoalResponseData(LocalDateTime time) {
        this.date = String.valueOf(time.getDayOfMonth());
        this.flag = Boolean.FALSE;
    }
}
