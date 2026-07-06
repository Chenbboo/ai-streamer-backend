package com.ruoyi.live.service;

import java.util.Map;

public interface ILiveStatsService
{
    public Map<String, Object> getWeeklyStats(String beginDate, String endDate, Long streamerId);
}
