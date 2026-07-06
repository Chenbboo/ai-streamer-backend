-- AI recognition config. Run in `ry-vue`.
delete from sys_config where config_key in (
  'live.ai.enabled',
  'live.ai.provider',
  'live.ai.model',
  'live.ai.apiKey',
  'live.ai.baseUrl',
  'live.ai.timeout'
);

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark) values
('Live AI Enabled', 'live.ai.enabled', 'false', 'N', 'admin', sysdate(), 'true=real AI,false=Mock'),
('Live AI Provider', 'live.ai.provider', 'openai-compatible-chat', 'N', 'admin', sysdate(), 'mock/openai-responses/openai-compatible-chat'),
('Live AI Model', 'live.ai.model', 'gpt-4o-mini', 'N', 'admin', sysdate(), 'vision/text model from selected provider'),
('Live AI API Key', 'live.ai.apiKey', '', 'N', 'admin', sysdate(), 'OpenAI API Key'),
('Live AI Base URL', 'live.ai.baseUrl', 'https://api.openai.com/v1/chat/completions', 'N', 'admin', sysdate(), 'full endpoint URL'),
('Live AI Timeout', 'live.ai.timeout', '60', 'N', 'admin', sysdate(), 'seconds');
