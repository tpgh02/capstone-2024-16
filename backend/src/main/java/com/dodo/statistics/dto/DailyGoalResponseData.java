package com.dodo.statistics.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class DailyGoalResponseData {
    String date;
    Boolean flag;

    public DailyGoalResponseData(LocalDateTime time) {
        this.date = String.valueOf(time.getDayOfMonth());
        this.flag = Boolean.FALSE;
    }

    public DailyGoalResponseData(int date) {
        this.date = String.valueOf(date);
        this.flag = Boolean.FALSE;
    }
}
