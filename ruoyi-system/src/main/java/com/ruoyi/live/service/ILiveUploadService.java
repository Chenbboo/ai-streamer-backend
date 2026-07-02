package com.ruoyi.live.service;

import java.util.List;
import com.ruoyi.live.domain.LiveDailySummary;
import com.ruoyi.live.domain.LiveUpload;

/**
 * 上传记录 服务层
 */
public interface ILiveUploadService
{
    public List<LiveUpload> selectLiveUploadList(LiveUpload upload);

    public LiveUpload selectLiveUploadById(Long uploadId);

    public List<LiveDailySummary> selectDailySummary(LiveUpload upload);

    public int insertLiveUpload(LiveUpload upload);

    /**
     * 删除上传记录,同时删除磁盘文件
     */
    public int deleteLiveUploadByIds(Long[] uploadIds);
}
