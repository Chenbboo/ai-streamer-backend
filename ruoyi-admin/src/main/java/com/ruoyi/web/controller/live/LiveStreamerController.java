package com.ruoyi.web.controller.live;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.live.domain.LiveStreamer;
import com.ruoyi.live.service.ILiveStreamerService;

/**
 * 主播信息
 */
@RestController
@RequestMapping("/live/streamer")
public class LiveStreamerController extends BaseController
{
    @Autowired
    private ILiveStreamerService streamerService;

    /**
     * 在职主播下拉列表
     */
    @PreAuthorize("@ss.hasPermi('live:upload:list')")
    @GetMapping("/listAll")
    public AjaxResult listAll()
    {
        LiveStreamer query = new LiveStreamer();
        query.setStatus("0");
        List<LiveStreamer> list = streamerService.selectLiveStreamerList(query);
        return success(list);
    }
}
