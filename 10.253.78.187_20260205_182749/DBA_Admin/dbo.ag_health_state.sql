-- Object: TABLE dbo.ag_health_state
-- Server: 10.253.78.187 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[ag_health_state]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [replica_server_name] NVARCHAR(256) NULL,
    [is_primary_replica] BIT NULL,
    [database_name] NVARCHAR(128) NULL,
    [ag_name] NVARCHAR(128) NULL,
    [ag_listener] NVARCHAR(114) NULL,
    [is_local] BIT NULL,
    [is_distributed] BIT NULL,
    [synchronization_state_desc] NVARCHAR(60) NULL,
    [synchronization_health_desc] NVARCHAR(60) NULL,
    [latency_seconds] INT NULL,
    [redo_queue_size] BIGINT NULL,
    [log_send_queue_size] BIGINT NULL,
    [last_redone_time] DATETIME NULL,
    [log_send_rate] BIGINT NULL,
    [redo_rate] BIGINT NULL,
    [estimated_redo_completion_time_min] NUMERIC(26, 6) NULL,
    [last_commit_time] DATETIME NULL,
    [is_suspended] BIT NULL,
    [suspend_reason_desc] NVARCHAR(60) NULL
);

GO
