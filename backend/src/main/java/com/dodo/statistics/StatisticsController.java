package com.dodo.statistics;

import com.dodo.config.auth.CustomAuthentication;
import com.dodo.statistics.dto.ReportResponseData;
import com.dodo.statistics.dto.SimpleReportResponseData;
import com.dodo.statistics.dto.WeeklyGoalResponseData;
import com.dodo.user.domain.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/report")
@RequiredArgsConstructor
@CustomAuthentication
public class StatisticsController {
    private final StatisticsService statisticsService;

    @GetMapping("/simple")
    public SimpleReportResponseData getSimpleReport(
            @RequestAttribute UserContext userContext,
            @RequestParam Long roomId
    ) {
        return statisticsService.getSimpleReport(userContext, roomId);
    }

    @GetMapping("/me")
    public ReportResponseData getReport(
            @RequestAttribute UserContext userContext
    ) {
        return statisticsService.getReport(userContext);
    }

    @GetMapping("/weekly")
    public List<WeeklyGoalResponseData> getWeeklyGoal(
            @RequestAttribute UserContext userContext
    ) {
        return statisticsService.getWeeklyGoal(userContext);
    }


}
