-- Object: TABLE dbo.xevent_metrics
-- Server: 10.253.33.227 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[xevent_metrics]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [event_name] NVARCHAR(60) NOT NULL,
    [session_id] INT NOT NULL,
    [request_id] INT NOT NULL,
    [result] VARCHAR(50) NULL,
    [database_name] VARCHAR(255) NULL,
    [client_app_name] VARCHAR(255) NULL,
    [username] VARCHAR(255) NULL,
    [cpu_time_ms] BIGINT NULL,
    [duration_seconds] BIGINT NULL,
    [logical_reads] BIGINT NULL,
    [physical_reads] BIGINT NULL,
    [row_count] BIGINT NULL,
    [writes] BIGINT NULL,
    [spills] BIGINT NULL,
    [client_hostname] VARCHAR(255) NULL,
    [session_resource_pool_id] INT NULL,
    [session_resource_group_id] INT NULL,
    [scheduler_id] INT NULL
);

GO
