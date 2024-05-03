package com.dodo.statistics.dto;

import lombok.Data;

import java.util.List;

@Data
public class SimpleReportResponseData {
    List<DailyGoalResponseData> calender;
    private Float lastMonth;
    private Float thisMonth;

    public SimpleReportResponseData(List<DailyGoalResponseData> calender, long lastMonthCount, long lastMonthSize, long thisMonthCount, long thisMonthSize) {
        this.calender = calender;
        this.lastMonth = (float) thisMonthCount / (float) thisMonthSize;
        this.thisMonth = (float) lastMonthCount / (float) lastMonthSize;
    }
}
