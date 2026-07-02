package com.ruoyi.live.service.impl;

import java.io.File;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.live.domain.LiveDailySummary;
import com.ruoyi.live.domain.LiveUpload;
import com.ruoyi.live.mapper.LiveUploadMapper;
import com.ruoyi.live.service.ILiveUploadService;

/**
 * 上传记录 服务实现
 */
@Service
public class LiveUploadServiceImpl implements ILiveUploadService
{
    @Autowired
    private LiveUploadMapper uploadMapper;

    @Override
    public List<LiveUpload> selectLiveUploadList(LiveUpload upload)
    {
        return uploadMapper.selectLiveUploadList(upload);
    }

    @Override
    public LiveUpload selectLiveUploadById(Long uploadId)
    {
        return uploadMapper.selectLiveUploadById(uploadId);
    }

    @Override
    public List<LiveDailySummary> selectDailySummary(LiveUpload upload)
    {
        return uploadMapper.selectDailySummary(upload);
    }

    @Override
    public int insertLiveUpload(LiveUpload upload)
    {
        return uploadMapper.insertLiveUpload(upload);
    }

    @Override
    @Transactional
    public int deleteLiveUploadByIds(Long[] uploadIds)
    {
        // 先查出文件路径,删库成功后删磁盘文件
        List<LiveUpload> records = uploadMapper.selectLiveUploadByIds(uploadIds);
        int rows = uploadMapper.deleteLiveUploadByIds(uploadIds);
        if (rows > 0)
        {
            for (LiveUpload record : records)
            {
                String filePath = record.getFilePath();
                if (StringUtils.isNotEmpty(filePath) && filePath.startsWith(Constants.RESOURCE_PREFIX))
                {
                    String absPath = RuoYiConfig.getProfile() + StringUtils.substringAfter(filePath, Constants.RESOURCE_PREFIX);
                    File file = new File(absPath);
                    if (file.exists())
                    {
                        file.delete();
                    }
                }
            }
        }
        return rows;
    }
}
