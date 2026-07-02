package com.ruoyi.live.mapper;

import java.util.List;
import com.ruoyi.live.domain.LiveDailySummary;
import com.ruoyi.live.domain.LiveUpload;

/**
 * 上传记录 数据层
 */
public interface LiveUploadMapper
{
    public List<LiveUpload> selectLiveUploadList(LiveUpload upload);

    public LiveUpload selectLiveUploadById(Long uploadId);

    public List<LiveDailySummary> selectDailySummary(LiveUpload upload);

    public int insertLiveUpload(LiveUpload upload);

    public int deleteLiveUploadByIds(Long[] uploadIds);

    public List<LiveUpload> selectLiveUploadByIds(Long[] uploadIds);
}
