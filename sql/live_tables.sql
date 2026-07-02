-- ----------------------------
-- AI 主播直播数据统计 — 业务表
-- 在 ry-vue 库执行。字符集 utf8mb4(昵称含 emoji/韩文/越南文)。
-- ----------------------------

-- 1. 主播扩展表(登录账号复用 sys_user,这里存平台信息)
drop table if exists live_streamer;
create table live_streamer (
  streamer_id     bigint(20)   not null auto_increment    comment '主播ID',
  user_id         bigint(20)   not null                   comment '关联 sys_user.user_id',
  tiktok_handle   varchar(100) default ''                 comment 'TikTok 账号(@handle)',
  stage_name      varchar(100) not null                   comment '艺名/汇报用名(如 Zhenzhen)',
  status          char(1)      default '0'                comment '状态(0在职 1离职)',
  create_by       varchar(64)  default '',
  create_time     datetime,
  update_by       varchar(64)  default '',
  update_time     datetime,
  remark          varchar(500) default null,
  primary key (streamer_id),
  unique key uk_user_id (user_id),
  key idx_stage_name (stage_name)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='主播信息表';

-- 2. 客户表(身份以昵称为准;改名靠人工合并)
drop table if exists live_customer;
create table live_customer (
  customer_id     bigint(20)   not null auto_increment    comment '客户ID',
  nickname        varchar(200) not null                   comment '客户昵称(截图识别原文)',
  profile_url     varchar(300) default ''                 comment 'TikTok 主页链接(人工核实填写)',
  avatar_path     varchar(300) default ''                 comment '头像小图路径(识别时截取,辅助认人)',
  badge           varchar(50)  default ''                 comment '粉丝团徽章(如 MWRM)',
  merged_into_id  bigint(20)   default null               comment '已合并到的客户ID(null=正常;非null=此昵称是别名)',
  first_seen_date date         default null               comment '首次出现日期',
  last_seen_date  date         default null               comment '最近出现日期',
  create_by       varchar(64)  default '',
  create_time     datetime,
  update_by       varchar(64)  default '',
  update_time     datetime,
  remark          varchar(500) default null               comment '运营备注(地区/消费力/性格等)',
  primary key (customer_id),
  unique key uk_nickname (nickname),
  key idx_merged (merged_into_id)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='客户表';

-- 3. 上传记录表(每张截图/每段汇报文本一条)
drop table if exists live_upload;
create table live_upload (
  upload_id       bigint(20)   not null auto_increment    comment '上传ID',
  biz_date        date         not null                   comment '业务日期(数据属于哪一天)',
  streamer_id     bigint(20)   not null                   comment '主播ID',
  upload_type     char(1)      not null                   comment '类型(1打赏榜截图 2聊天截图 3汇报文本)',
  file_path       varchar(300) default ''                 comment '文件路径(类型3为空)',
  raw_text        text         default null               comment '汇报原文(类型3)',
  ai_status       char(1)      default '0'                comment 'AI识别状态(0待识别 1已识别 2已校正入库 3识别失败)',
  ai_result       json         default null               comment 'AI识别原始JSON(留痕,校正对照用)',
  upload_by       bigint(20)   default null               comment '上传人 sys_user.user_id',
  create_time     datetime,
  update_time     datetime,
  primary key (upload_id),
  key idx_date_streamer (biz_date, streamer_id),
  key idx_status (ai_status)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='上传记录表';

-- 4. 打赏明细表(按天,同一客户当天多张截图去重后一条)
drop table if exists live_gift_record;
create table live_gift_record (
  gift_id         bigint(20)   not null auto_increment    comment '记录ID',
  biz_date        date         not null                   comment '日期',
  streamer_id     bigint(20)   not null                   comment '主播ID',
  customer_id     bigint(20)   not null                   comment '客户ID',
  xu              int          not null default 0         comment 'Xu 数',
  rank_no         int          default null               comment '榜单排名',
  upload_id       bigint(20)   default null               comment '来源截图',
  confirm_status  char(1)      default '0'                comment '校正状态(0待校正 1已确认)',
  ai_confidence   char(1)      default '1'                comment 'AI置信度(0低-需重点核对 1正常)',
  create_time     datetime,
  update_by       varchar(64)  default ''                 comment '校正人',
  update_time     datetime,
  primary key (gift_id),
  unique key uk_date_streamer_customer (biz_date, streamer_id, customer_id),
  key idx_customer (customer_id),
  key idx_date (biz_date)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='打赏明细表(日粒度)';

-- 5. 聊天互动表(一期:主播×客户×日期一条,证明当天跟进过)
drop table if exists live_chat_contact;
create table live_chat_contact (
  contact_id      bigint(20)   not null auto_increment    comment '记录ID',
  biz_date        date         not null                   comment '日期',
  streamer_id     bigint(20)   not null                   comment '主播ID',
  customer_id     bigint(20)   not null                   comment '客户ID',
  upload_id       bigint(20)   default null               comment '来源截图(证据)',
  create_time     datetime,
  primary key (contact_id),
  unique key uk_date_streamer_customer (biz_date, streamer_id, customer_id),
  key idx_customer (customer_id)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='聊天互动表(日粒度)';

-- 6. 聊天消息表(二期:逐条消息,供 AI 月度评估;一期建表不写入)
drop table if exists live_chat_message;
create table live_chat_message (
  msg_id          bigint(20)   not null auto_increment    comment '消息ID',
  biz_date        date         not null                   comment '日期',
  streamer_id     bigint(20)   not null                   comment '主播ID',
  customer_id     bigint(20)   not null                   comment '客户ID',
  sender          char(1)      not null                   comment '发送方(1主播 2客户)',
  content_type    char(1)      default '1'                comment '内容类型(1文字 2贴图/表情 3图片 4语音 9其他)',
  content         text         default null               comment '消息文本(非文字类型存描述)',
  msg_time        varchar(50)  default ''                 comment '截图上显示的时间(原文)',
  seq_no          int          default 0                  comment '对话内顺序号',
  upload_id       bigint(20)   default null               comment '来源截图',
  create_time     datetime,
  primary key (msg_id),
  key idx_date_streamer_customer (biz_date, streamer_id, customer_id),
  key idx_customer (customer_id)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='聊天消息表(二期)';

-- 7. 每日汇报表(主播自报,不与明细对账)
drop table if exists live_daily_report;
create table live_daily_report (
  report_id       bigint(20)   not null auto_increment    comment '汇报ID',
  biz_date        date         not null                   comment '日期',
  streamer_id     bigint(20)   not null                   comment '主播ID',
  total_xu        int          not null default 0         comment '自报总 Xu',
  raw_text        varchar(500) default ''                 comment '汇报原文',
  upload_id       bigint(20)   default null               comment '来源上传记录',
  create_time     datetime,
  update_by       varchar(64)  default '',
  update_time     datetime,
  primary key (report_id),
  unique key uk_date_streamer (biz_date, streamer_id),
  key idx_date (biz_date)
) engine=innodb auto_increment=100 default charset=utf8mb4 collate=utf8mb4_unicode_ci comment='每日汇报表';
