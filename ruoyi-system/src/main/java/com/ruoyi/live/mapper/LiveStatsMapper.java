package com.ruoyi.live.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface LiveStatsMapper
{
    public List<Map<String, Object>> selectStreamerCards(@Param("beginDate") String beginDate,
                                                         @Param("endDate") String endDate,
                                                         @Param("streamerId") Long streamerId);

    public List<Map<String, Object>> selectPreviousTotals(@Param("beginDate") String beginDate,
                                                          @Param("endDate") String endDate,
                                                          @Param("streamerId") Long streamerId);

    public List<Map<String, Object>> selectTrend(@Param("beginDate") String beginDate,
                                                 @Param("endDate") String endDate,
                                                 @Param("streamerId") Long streamerId);

    public List<Map<String, Object>> selectCustomerCards(@Param("beginDate") String beginDate,
                                                         @Param("endDate") String endDate,
                                                         @Param("streamerId") Long streamerId);
}
