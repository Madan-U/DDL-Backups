-- Object: TABLE dbo.wait_stats
-- Server: 10.253.33.190 | DB: DBA_Admin
--------------------------------------------------

CREATE TABLE [dbo].[wait_stats]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [wait_type] NVARCHAR(60) NOT NULL,
    [waiting_tasks_count] BIGINT NOT NULL,
    [wait_time_ms] BIGINT NOT NULL,
    [max_wait_time_ms] BIGINT NOT NULL,
    [signal_wait_time_ms] BIGINT NOT NULL
);

GO
