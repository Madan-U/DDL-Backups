-- Object: TRIGGER dbo.tgr_insert_xevent_metrics
-- Server: 10.253.78.167 | DB: DBA_Admin
--------------------------------------------------


create trigger dbo.tgr_insert_xevent_metrics on dbo.vw_xevent_metrics
instead of insert as
begin
	set nocount on;

	insert dbo.xevent_metrics
	(	[row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id] )
	select [row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id]
	from inserted;

	insert dbo.xevent_metrics_queries
	(	[row_id], [start_time], [event_time], [sql_text] )
	select [row_id], [start_time], [event_time], [sql_text]
	from inserted;
end

GO
