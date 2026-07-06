package com.ruoyi.web.controller.live;

import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.live.domain.LiveStreamer;
import com.ruoyi.live.service.ILiveStatsService;
import com.ruoyi.live.service.ILiveStreamerService;

@RestController
@RequestMapping("/live/stats")
public class LiveStatsController extends BaseController
{
    @Autowired
    private ILiveStatsService statsService;

    @Autowired
    private ILiveStreamerService streamerService;

    @PreAuthorize("@ss.hasPermi('live:stats:list')")
    @GetMapping("/weekly")
    public AjaxResult weekly(String beginDate, String endDate, Long streamerId)
    {
        LocalDate end = StringUtils.isEmpty(endDate) ? LocalDate.now() : LocalDate.parse(endDate);
        LocalDate begin = StringUtils.isEmpty(beginDate) ? end.minusDays(6) : LocalDate.parse(beginDate);
        LiveStreamer own = getOwnStreamerIfRestricted();
        Long effectiveStreamerId = own == null ? streamerId : own.getStreamerId();
        return AjaxResult.success(statsService.getWeeklyStats(begin.toString(), end.toString(), effectiveStreamerId));
    }

    private LiveStreamer getOwnStreamerIfRestricted()
    {
        SysUser user = SecurityUtils.getLoginUser().getUser();
        if (user.isAdmin())
        {
            return null;
        }
        boolean hasElevated = false;
        boolean isStreamer = false;
        for (SysRole role : user.getRoles())
        {
            String key = role.getRoleKey();
            if ("operator".equals(key) || "live_admin".equals(key))
            {
                hasElevated = true;
            }
            if ("streamer".equals(key))
            {
                isStreamer = true;
            }
        }
        if (hasElevated || !isStreamer)
        {
            return null;
        }
        LiveStreamer own = streamerService.selectLiveStreamerByUserId(user.getUserId());
        if (own == null)
        {
            throw new ServiceException("当前账号未绑定主播信息，请联系管理员");
        }
        return own;
    }
}
