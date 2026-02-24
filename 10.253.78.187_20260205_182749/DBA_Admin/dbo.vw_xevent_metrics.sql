-- Object: VIEW dbo.vw_xevent_metrics
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------


CREATE VIEW [dbo].[vw_xevent_metrics]
WITH SCHEMABINDING 
AS
SELECT rc.[row_id], rc.[start_time], rc.[event_time], rc.[event_name], rc.[session_id], rc.[request_id], rc.[result], rc.[database_name], rc.[client_app_name], rc.[username], rc.[cpu_time_ms], rc.[duration_seconds], rc.[logical_reads], rc.[physical_reads], rc.[row_count], rc.[writes], rc.[spills], txt.[sql_text], /* rc.[query_hash], rc.[query_plan_hash], */ rc.[client_hostname], rc.[session_resource_pool_id], rc.[session_resource_group_id], rc.[scheduler_id]
FROM [dbo].[xevent_metrics] rc
LEFT JOIN [dbo].[xevent_metrics_queries] txt
	ON rc.event_time = txt.event_time
	AND rc.start_time = txt.start_time
	AND rc.row_id = txt.row_id

GO
