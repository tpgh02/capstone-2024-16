package com.dodo.statistics.dto;

import lombok.Data;

@Data
public class SimpleReportResponseData {
    private Float lastMonth;
    private Float thisMonth;

    public SimpleReportResponseData(long lastMonthCount, long lastMonthSize, long thisMonthCount, long thisMonthSize) {
        this.lastMonth = (float) thisMonthCount / (float) thisMonthSize;
        this.thisMonth = (float) lastMonthCount / (float) lastMonthSize;
    }
}
