package com.dodo.statistics.dto;

import com.dodo.room.domain.Category;
import lombok.Data;

import java.util.Map;

@Data
public class ReportResponseData {
    private Float lastMonth;
    private Float thisMonth;
    private Map<Category, Long> categorySize;
    private Integer allCategorySize;
    private Float mostActivity;

    public ReportResponseData(float lastMonth, float thisMonth, Map<Category, Long> categoryStatus, Integer allCategoryStatus, Float mostActivity) {
        this.lastMonth = lastMonth;
        this.thisMonth = thisMonth;
        this.categorySize = categoryStatus;
        this.allCategorySize = allCategoryStatus;
        this.mostActivity = mostActivity;
    }
}
