package com.dodo.statistics.dto;

import lombok.Data;

@Data
public class SimpleReportResponseData {
    private Float thisMonth;
    private Float lastMonth;

    public SimpleReportResponseData(long lastMonthCount, long lastMonthSize, long thisMonthCount, long thisMonthSize) {
        this.thisMonth = (float) lastMonthCount / (float) lastMonthSize;
        this.lastMonth = (float) thisMonthCount / (float) thisMonthSize;
    }
}
